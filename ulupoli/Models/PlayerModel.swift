import Foundation

struct PlayerModel: Identifiable, Decodable, Equatable {
    let uuid = UUID()
    
    var id: Int?
    var name: String
    var role: Int?
    var status: Int?
    var room_id: Int?
    var card_id: Int?
    var deleted_at: Date?
    var created_at: Date
    var updated_at: Date
    
    let latitude: Double?
    let longitude: Double?
    
    var idForList: UUID {
        return uuid
    }
    
    // ミッションで必要
    static func == (lhs: PlayerModel, rhs: PlayerModel) -> Bool {
        guard let lhsCardId = lhs.card_id, let rhsCardId = rhs.card_id else {
            return false
        }
        return lhsCardId == rhsCardId
    }
}
