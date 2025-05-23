import Foundation

class PlayerViewModel: ObservableObject {
    @Published var nameInput: String = ""
    @Published var roomIDInput: String = ""
    @Published var cardIDInput: String = ""
    
    @Published var player: PlayerModel?
    
    func savePlayer() {
        let now = Date()
        player = PlayerModel(
            name: nameInput, // 必要に応じて変更
            rool: 0,
            status: 0,
            room_id: roomIDInput,
            card_id: cardIDInput,
            deleted_at: now,
            created_at: now,
            updated_at: now
        )
        print("ちゃんとできてる？\(player)")
    }
}
