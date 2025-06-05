// PlayerModel.swift (修正版)
import Foundation

struct PlayerModel: Identifiable, Decodable, Equatable {
    // --- Identifiable準拠のため、UI表示専用の一意なIDを追加 ---
    let uuid = UUID()
    
    // --- 元のプロパティ ---
    var id: Int?
    var name: String
    var roll: Int
    var status: Int
    var room_id: Int?
    var card_id: Int?
    var deleted_at: Date?
    var created_at: Date
    var updated_at: Date
    
    // --- Identifiableプロトコルの要件 ---
    // Listで使うため、uuidをidとして公開する
    var idForList: UUID {
        return uuid
    }
    
    // card_idが同じであれば、同じプレイヤーとみなす
    static func == (lhs: PlayerModel, rhs: PlayerModel) -> Bool {
        // 両方のcard_idがnilでなく、かつ等しい場合にtrueを返す
        guard let lhsCardId = lhs.card_id, let rhsCardId = rhs.card_id else {
            return false
        }
        return lhsCardId == rhsCardId
    }
}
