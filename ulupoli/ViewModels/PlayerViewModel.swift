import Foundation
import Supabase

struct InsertPlayerModel: Encodable {
    let name: String
    let status: Int
    let room_id: Int
    let card_id: Int
    let created_at: Date
    let updated_at: Date
}

class PlayerViewModel: ObservableObject {
    @Published var nameInput: String = ""
    @Published var roomIDInput: String = ""
    @Published var cardIDInput: String = ""
    @Published var errorMessage: String?        // エラーメッセージ（ある場合）
    @Published var isLoading: Bool = false      // ローディング中フラグ

    
    @Published var player: PlayerModel?
    
    //スタート前の諸々の処理系(roomID playerのname cardID 待機室入室までの処理)
    @MainActor
    func joinRoom() async {
        // すでにルーム ID が空白だったら弾く
        if roomIDInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errorMessage = "ルームIDを入力してください"
            return
        }
        isLoading = true
        errorMessage = nil

        do {
            print("roomID")
            print(roomIDInput)
            // STEP A: rooms テーブルから room_random_id が一致する行を検索
            let roomsResponse: PostgrestResponse<[RoomModel]> = try await SupabaseManager.shared.client.from("rooms")
                .select().eq("random_room_id", value: roomIDInput).execute()
            if let matchedRoom = roomsResponse.value.first {
                // STEP B: players テーブルに「空の Player レコード」を作成
                let now = Date()
                let cardResponse: PostgrestResponse<[CardModel]> = try await SupabaseManager.shared.client.from("cards").select().eq("default_id", value: cardIDInput).execute()
                guard let matchedCard = cardResponse.value.first else {
                    self.errorMessage = "該当するカードが見つかりません"
                    isLoading = false
                    return
                }

                let newPlayer = InsertPlayerModel(name: nameInput, status: 1,room_id: matchedRoom.id, card_id: matchedCard.id,created_at: now, updated_at: now)
//                let newPlayer = PlayerModel(
//                    id: nil,
//                    name: "",                       // 名前は未入力なので空文字
//                    roll: 0,
//                    status: 0,
//                    room_id: matchedRoom.id,          // 取得した rooms.id をセット
//                    card_id: nil,                   // NFC カードはまだ未スキャン
//                    deleted_at: nil,
//                    created_at: now,
//                    updated_at: now
//                )
                let insertResponse: PostgrestResponse<[PlayerModel]> = try await SupabaseManager.shared.client
                    .from("players")
                    .insert(newPlayer)
                    .select()   // 挿入後のレコードを返却
                    .execute()
                
                print("player作れた")
                if let inserted = insertResponse.value.first {
                    // player プロパティに作成済みレコードを保持
                    self.player = inserted
                } else {
                    self.errorMessage = "プレイヤーの作成に失敗しました"
                }
            } else {
                // 該当ルームなし
                self.errorMessage = "該当するルームが見つかりません"
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }

        isLoading = false
    }
    
    //捕まった時に捕まった人のroleを変更する
    func updatePlayerRoleByCardDefaultID(_ defaultID: String) async {
        do {
            // Step 1: default_id から card を取得
            let cardResponse: PostgrestResponse<[CardModel]> = try await SupabaseManager.shared.client
                .from("cards")
                .select()
                .eq("default_id", value: defaultID)
                .limit(1)
                .execute()

            guard let card = cardResponse.value.first else {
                self.errorMessage = "該当するカードが見つかりません"
                return
            }

            let cardID = card.id

            // Step 2: card_id を持つプレイヤーの roll を 3 に更新
            let updateResponse = try await SupabaseManager.shared.client
                .from("players")
                .update(["roll": 3])
                .eq("card_id", value: cardID)
                .execute()

            print("更新成功: \(updateResponse)")
        } catch {
            self.errorMessage = "更新失敗: \(error.localizedDescription)"
        }
    }

    
//    func savePlayer() {
//        let now = Date()
//        player = PlayerModel(
//            name: nameInput, // 必要に応じて変更
//            rool: 0,
//            status: 0,
//            room_id: roomIDInput,
//            card_id: cardIDInput,
//            deleted_at: now,
//            created_at: now,
//            updated_at: now
//        )
//        print("ちゃんとできてる？\(player)")
//    }
}
