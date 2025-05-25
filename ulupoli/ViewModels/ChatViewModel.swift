import Foundation
import Combine

// クラス宣言の @MainActor は外したままにします
class ChatViewModel: ObservableObject {
    
    @Published var messages: [MessageModel] = []
    @Published var players: [UUID: ChatPlayerModel] = [:]
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var inputText: String = ""
    
    let currentUserId: UUID
    private let chatService: ChatServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(chatService: ChatServiceProtocol = MockChatService()) {
        self.chatService = chatService
        if let mockService = chatService as? MockChatService {
            self.currentUserId = mockService.currentPlayer.id
        } else {
            self.currentUserId = UUID()
        }
    }
    
    // @MainActor をメソッドに付けつつ、更新箇所でも MainActor.run を使う
    @MainActor
    func loadInitialData() {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let fetchedMessages = try await chatService.fetchMessages()
                let playerIds = Set(fetchedMessages.map { $0.senderId })
                let fetchedPlayers = try await chatService.fetchPlayers(ids: Array(playerIds))
                
                // --- ここで MainActor.run を使って更新を保証 ---
                await MainActor.run {
                    self.messages = fetchedMessages
                    self.players = fetchedPlayers.reduce(into: [:]) { dict, player in
                        dict[player.id] = player
                    }
                    self.isLoading = false
                }
                // --- ここまで ---
            } catch {
                // --- ここでも MainActor.run を使う ---
                await MainActor.run {
                    self.errorMessage = "データの読み込みに失敗しました: \(error.localizedDescription)"
                    self.isLoading = false
                }
                // --- ここまで ---
            }
        }
    }
    
    @MainActor
    func sendMessage() {
        let textToSend = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !textToSend.isEmpty else { return }
        
        let tempMessageId = UUID()
        let tempMessage = MessageModel(id: tempMessageId, message: textToSend, senderId: currentUserId)
        
        messages.append(tempMessage)
        inputText = ""
        
        Task {
            do {
                try await chatService.sendMessage(textToSend, senderId: currentUserId)
                print("送信成功")
            } catch {
                // --- MainActor.run を使う ---
                await MainActor.run {
                    self.errorMessage = "メッセージの送信に失敗しました。"
                    self.messages.removeAll { $0.id == tempMessageId }
                    self.inputText = textToSend
                }
                // --- ここまで ---
            }
        }
    }
    
    func getPlayer(for id: UUID) -> ChatPlayerModel {
        return players[id] ?? .unknown
    }
    
    func startListening() {
        chatService.listenForNewMessages { [weak self] result in
            // --- Task { @MainActor in ... } を使う ---
            Task { @MainActor in
                guard let self = self else { return }
                switch result {
                case .success(let newMessage):
                    if !self.messages.contains(where: { $0.id == newMessage.id }) {
                        self.messages.append(newMessage) // @MainActor 内なので安全
                        if self.players[newMessage.senderId] == nil {
                            self.fetchAndAddPlayer(id: newMessage.senderId) // これも @MainActor
                        }
                    }
                case .failure(let error):
                    self.errorMessage = "リアルタイム更新エラー: \(error.localizedDescription)" // @MainActor 内
                }
            }
            // --- ここまで ---
        }
        .store(in: &cancellables)
    }
    
    @MainActor
    private func fetchAndAddPlayer(id: UUID) {
        Task {
            do {
                let fetchedPlayers = try await self.chatService.fetchPlayers(ids: [id])
                // --- MainActor.run を使う (念のため) ---
                await MainActor.run {
                    if let newPlayer = fetchedPlayers.first {
                        self.players[newPlayer.id] = newPlayer
                    }
                }
                // --- ここまで ---
            } catch {
                print("新規プレイヤー情報の取得に失敗: \(error)")
            }
        }
    }
}
