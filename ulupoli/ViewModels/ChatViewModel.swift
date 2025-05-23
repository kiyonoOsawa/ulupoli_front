import Foundation
import Combine

//@MainActor // UI更新はメインスレッドで行うことを保証
class ChatViewModel: ObservableObject {
    
    @Published var messages: [MessageModel] = []
    @Published var players: [UUID: ChatPlayerModel] = [:] // IDでプレイヤーを引けるように辞書型に
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var inputText: String = ""
    
    let currentUserId: UUID // 現在のユーザーIDを保持
    private let chatService: ChatServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(chatService: ChatServiceProtocol = MockChatService()) {
        self.chatService = chatService
        // MockChatService から currentPlayer の ID を取得 (本来は認証情報などから)
        if let mockService = chatService as? MockChatService {
            self.currentUserId = mockService.currentPlayer.id
        } else {
            self.currentUserId = UUID() // フォールバック
        }
    }
    
    // メッセージと関連プレイヤーをロードする
    func loadInitialData() {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let fetchedMessages = try await chatService.fetchMessages()
                self.messages = fetchedMessages
                
                // メッセージから必要なプレイヤーIDを抽出
                let playerIds = Set(fetchedMessages.map { $0.senderId })
                let fetchedPlayers = try await chatService.fetchPlayers(ids: Array(playerIds))
                
                // プレイヤーを辞書に格納
                self.players = fetchedPlayers.reduce(into: [:]) { dict, player in
                    dict[player.id] = player
                }
                
                isLoading = false
            } catch {
                errorMessage = "データの読み込みに失敗しました: \(error.localizedDescription)"
                isLoading = false
            }
        }
    }
    
    // メッセージを送信する
    func sendMessage() {
        let textToSend = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !textToSend.isEmpty else { return }
        
        let tempMessageId = UUID() // 一時的なID
        let tempMessage = MessageModel(id: tempMessageId, message: textToSend, senderId: currentUserId)
        
        // UIに即時反映
        messages.append(tempMessage)
        inputText = ""
        
        Task {
            do {
                try await chatService.sendMessage(textToSend, senderId: currentUserId)
                // 送信成功時の処理 (例: メッセージの状態を 'sent' にするなど)
                // 今回はモックなので特に行わない
                print("送信成功")
                // 必要であれば、サーバーから返された正式なメッセージで置き換える
            } catch {
                errorMessage = "メッセージの送信に失敗しました。"
                // 送信失敗時の処理 (例: メッセージを 'failed' 状態にする、再送ボタンを出すなど)
                // 今回は一時メッセージを削除する例
                messages.removeAll { $0.id == tempMessageId }
                inputText = textToSend // 入力内容を戻す
            }
        }
    }
    
    // プレイヤー情報を取得する
    func getPlayer(for id: UUID) -> ChatPlayerModel {
        return players[id] ?? .unknown // 見つからない場合は '不明' を返す
    }
    
    // リアルタイム更新のリスニングを開始する
    func startListening() {
        chatService.listenForNewMessages { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let newMessage):
                // 新しいメッセージが自分の送信したものでなければ追加
                if !self.messages.contains(where: { $0.id == newMessage.id }) {
                    self.messages.append(newMessage)
                    // 新しいプレイヤーがいれば取得・追加
                    if self.players[newMessage.senderId] == nil {
                        Task {
                            do {
                                let fetchedPlayers = try await self.chatService.fetchPlayers(ids: [newMessage.senderId])
                                if let newPlayer = fetchedPlayers.first {
                                    self.players[newPlayer.id] = newPlayer
                                }
                            } catch {
                                print("新規プレイヤー情報の取得に失敗: \(error)")
                            }
                        }
                    }
                }
            case .failure(let error):
                self.errorMessage = "リアルタイム更新エラー: \(error.localizedDescription)"
            }
        }
        .store(in: &cancellables) // サブスクリプションを保持
    }
}
