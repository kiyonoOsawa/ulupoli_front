import Foundation

// メッセージ情報 (Supabase の messages テーブルなどを想定)
struct MessageModel: Identifiable, Hashable, Codable {
    let id: UUID
    var message: String
    let senderId: UUID // 送信者のID (ChatPlayer.id とリンク)
    let createdAt: Date // 送信日時
    
    // Codable のための CodingKeys (もし Supabase のカラム名と違う場合)
    enum CodingKeys: String, CodingKey {
        case id, message
        case senderId = "sender_id"
        case createdAt = "created_at"
    }
    
    // イニシャライザ
    init(id: UUID = UUID(), message: String, senderId: UUID, createdAt: Date = Date()) {
        self.id = id
        self.message = message
        self.senderId = senderId
        self.createdAt = createdAt
    }
}
