import Foundation
import Supabase

final class PlayerRepository {
    
    static let shared = PlayerRepository()
    private let client: SupabaseClient
    
    private init() {
        self.client = SupabaseManager.shared.client
    }
    
    func fetchMyPlayer(byDefaultID defaultID: String) async throws -> PlayerModel? {
        // --- ステップ1: default_idを使って`cards`テーブルから`id`を取得 ---
        // このクエリでは、後続の処理に必要な`cards.id`のみを取得しています。
        
        // CardModelの一部だけをデコードするための一時的な構造体
        struct CardReference: Decodable {
            let id: Int
        }
        
        let cardResponse: [CardReference] = try await client
            .from("cards")
            .select("id")
            .eq("default_id", value: defaultID)
            .limit(1) // default_idは一意のはずなので、念のため1件に絞る
            .execute()
            .value
        
        // `cards`テーブルに該当するカードがなければ、プレイヤーも見つからないためnilを返す
        guard let foundCard = cardResponse.first else {
            print("リポジトリ: default_id `\(defaultID)` に一致するカードが見つかりませんでした。")
            return nil
        }
        
        // --- ステップ2: 取得した`card.id`を使って`players`テーブルを検索 ---
        
        // .single()を使わず配列で受けることで、「0件or複数件」エラーを防ぎます
        let playersResponse: [PlayerModel] = try await client
            .from("players")
            .select() // PlayerModelの全プロパティを取得
            .eq("card_id", value: foundCard.id) // ステップ1で取得したIDで絞り込む
            .execute()
            .value
        
        // 複数件見つかった場合でも、アプリを止めずに最初の1件を返す
        // 同時に、データ不整合の可能性をコンソールに警告として出力する
        if playersResponse.count > 1 {
            print("リポジトリ警告: card_id \(foundCard.id) に複数のプレイヤーが紐付いています。最初のプレイヤーを返します。")
        }
        
        // 配列の最初の要素を返す。配列が空（0件）の場合は自動的にnilが返される。
        return playersResponse.first
//        guard let myDefaultID = UserDefaults.standard.string(forKey: "myUID") else {
//            print("UserDefaultsからdefault_id(Int)が見つかりません。")
//            return nil
//        }
//        
//        let cardID: Int
//        do {
//            // ★★★ 2. 取得したデータをCardID構造体にデコードする ★★★
//            let foundCard: CardModel = try await client
//                .from("cards")
//                .select("id") // リクエストするのは`id`だけでOK
//                .eq("default_id", value: myDefaultID)
//                .single()
//                .execute()
//                .value
//            
//            cardID = foundCard.id
//            
//        } catch {
//            // ここでエラーが発生していた
//            print("cardsテーブルから対応するカードの取得に失敗しました: \(error)")
//            throw error
//        }
//        
//        do {
//            // PlayerModelの"配列"として結果を受け取るように変更
//            let players: [PlayerModel] = try await client
//                .from("players")
//                .select()
//                .eq("card_id", value: cardID)
//                .execute()
//                .value
//            
//            // --- 受け取った配列をチェックする ---
//            if let player = players.first {
//                // 配列の最初の要素を取得できれば、それが求めるプレイヤー
//                
//                // (推奨) もし複数件見つかった場合に警告を出すと、データ不整合の発見に役立つ
//                if players.count > 1 {
//                    print("警告: card_id \(cardID) に複数のプレイヤーが紐付いています。最初のプレイヤーを使用します。")
//                }
//                print("どうですか\(player)")
//                return player
//                
//            } else {
//                // 配列が空だった場合 = 該当するプレイヤーが見つからなかった
//                print("指定されたcard_id (\(cardID)) に一致するプレイヤーが見つかりませんでした。")
//                return nil
//            }
//            
//        } catch {
//            print("playersテーブルからプレイヤー情報の取得に失敗しました: \(error)")
//            throw error
//        }
    }
    
    func fetchRoomData(byRoomID roomID: Int) async throws -> RoomModel? {
        // .select() ですべてのカラムを取得し、RoomModel全体にデコードできるようにする
        let foundRoom: RoomModel? = try await client
            .from("rooms")
            .select() // "random_room_id"から変更
            .eq("id", value: roomID)
            .single() // 0件でもエラーにならないように
            .execute()
            .value
        
        return foundRoom
    }
}
