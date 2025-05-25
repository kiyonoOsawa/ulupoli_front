import Foundation
import Combine // リアルタイム更新のモック用

// チャットサービスが提供すべき機能の定義
protocol ChatServiceProtocol {
    func fetchMessages() async throws -> [MessageModel]
    func fetchPlayers(ids: [UUID]) async throws -> [ChatPlayerModel]
    func sendMessage(_ message: String, senderId: UUID) async throws
    // リアルタイム更新 (将来的には Supabase Realtime を使う)
    func listenForNewMessages(completion: @escaping (Result<MessageModel, Error>) -> Void) -> AnyCancellable
}

// モックチャットサービスの実装
class MockChatService: ChatServiceProtocol {
    
    // --- 擬似プレイヤー定義 ---
    let currentPlayer = ChatPlayerModel(name: "自分", avatar: "")
    let otherPlayer1 = ChatPlayerModel(name: "Alice", avatar: "avatar_alice")
    let otherPlayer2 = ChatPlayerModel(name: "Bob", avatar: "avatar_bob")
    
    private var mockMessages: [MessageModel]
    private var mockPlayers: [ChatPlayerModel]
    
    init() {
        self.mockPlayers = [currentPlayer, otherPlayer1, otherPlayer2]
        self.mockMessages = [
            MessageModel(message: "こんにちは、Aliceです！", senderId: otherPlayer1.id, createdAt: Date().addingTimeInterval(-120)),
            MessageModel(message: "やあ！", senderId: currentPlayer.id, createdAt: Date().addingTimeInterval(-60)),
            MessageModel(message: "元気？ Bobだよ。", senderId: otherPlayer2.id, createdAt: Date().addingTimeInterval(-30)),
            MessageModel(message: "元気だよ！", senderId: currentPlayer.id)
        ]
    }
    
    func fetchMessages() async throws -> [MessageModel] {
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5秒待機 (ネットワーク通信をシミュレート)
        return mockMessages
    }
    
    func fetchPlayers(ids: [UUID]) async throws -> [ChatPlayerModel] {
        try await Task.sleep(nanoseconds: 200_000_000) // 0.2秒待機
        return mockPlayers.filter { ids.contains($0.id) }
    }
    
    func sendMessage(_ message: String, senderId: UUID) async throws {
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1秒待機
        let newMessage = MessageModel(message: message, senderId: senderId)
        mockMessages.append(newMessage)
        print("メッセージ送信: \(message)")
        // 本来はここで Supabase に送信する
        
        // リアルタイム通知のシミュレーション (今回はここでは行わない)
    }
    
    // リアルタイム更新のモック (5秒ごとに Alice がメッセージを送るシミュレーション)
    func listenForNewMessages(completion: @escaping (Result<MessageModel, Error>) -> Void) -> AnyCancellable {
        Timer.publish(every: 5.0, on: .main, in: .common)
            .autoconnect()
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                let newMessage = MessageModel(
                    message: "これは \(Int.random(in: 1...100)) 番目の自動メッセージです。",
                    senderId: self.otherPlayer1.id
                )
                self.mockMessages.append(newMessage)
                completion(.success(newMessage))
            }
    }
}
