import Foundation
import SwiftUI
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
    @Published var room: RoomModel?
    private let playerRepository = PlayerRepository.shared
    
    //スタート前の諸々の処理系(roomID playerのname cardID 待機室入室までの処理)
    @MainActor
    func joinRoom() async throws {
        guard !isLoading else {
            print("joinRoom is already in progress. Skipping.")
            return
        }
        // 入力チェック
        if roomIDInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            let error = "ルームIDを入力してください"
            self.errorMessage = error
            // 簡易的なエラーをスロー
            throw NSError(domain: "PlayerViewModel", code: 400, userInfo: [NSLocalizedDescriptionKey: error])
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            // STEP A: rooms テーブルから room_random_id が一致する行を検索
            let roomsResponse: PostgrestResponse<[RoomModel]> = try await SupabaseManager.shared.client.from("rooms")
                .select().eq("random_room_id", value: roomIDInput).execute()
            
            guard let matchedRoom = roomsResponse.value.first else {
                let error = "該当するルームが見つかりません"
                self.errorMessage = error
                self.isLoading = false
                throw NSError(domain: "PlayerViewModel", code: 404, userInfo: [NSLocalizedDescriptionKey: error])
            }
            
            // STEP B: cards テーブルからカード情報を検索
            let cardResponse: PostgrestResponse<[CardModel]> = try await SupabaseManager.shared.client.from("cards").select().eq("default_id", value: cardIDInput).execute()
            
            guard let matchedCard = cardResponse.value.first else {
                let error = "該当するカードが見つかりません"
                self.errorMessage = error
                self.isLoading = false
                throw NSError(domain: "PlayerViewModel", code: 404, userInfo: [NSLocalizedDescriptionKey: error])
            }
            
            // STEP C: players テーブルに新しいプレイヤーを挿入
            let now = Date()
            let newPlayer = InsertPlayerModel(name: nameInput, status: 1, room_id: matchedRoom.id, card_id: matchedCard.id, created_at: now, updated_at: now)
            
            let insertResponse: PostgrestResponse<[PlayerModel]> = try await SupabaseManager.shared.client
                .from("players")
                .insert(newPlayer)
                .select()   // ★ 挿入したレコードを返してもらう
                .execute()
            
            if let insertedPlayer = insertResponse.value.first {
                // ★ 成功！挿入されたプレイヤー情報を self.player に格納する
                self.player = insertedPlayer
                print("プレイヤー作成成功: \(insertedPlayer.name)")
            } else {
                let error = "プレイヤーの作成に失敗しました"
                self.errorMessage = error
                throw NSError(domain: "PlayerViewModel", code: 500, userInfo: [NSLocalizedDescriptionKey: error])
            }
            
        } catch {
            // Supabaseからのエラーなどをキャッチ
            self.errorMessage = error.localizedDescription
            self.isLoading = false
            throw error // エラーを再スローして呼び出し元に伝える
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

    func fetchPlayerDataAfterNFC() {
        Task {
            await fetchPlayerData() // 既存のデータ取得ロジックを呼び出す
        }
    }
    
    func fetchPlayerData() async { // メソッド名をより汎用的に変更（任意）
        self.isLoading = true
        self.errorMessage = nil
        self.player = nil // 前回表示したデータをクリア
        self.room = nil   // 前回表示したデータをクリア
        
        guard let myDefaultID = UserDefaults.standard.string(forKey: "userDefaultID") else {
            self.errorMessage = "ログイン情報が見つかりません。"
            self.isLoading = false
            return
        }
        
        do {
            // --- 最初にプレイヤー情報を取得 ---
            let fetchedPlayer = try await playerRepository.fetchMyPlayer(byDefaultID: myDefaultID)
            self.player = fetchedPlayer
            
            // --- 次に、取得したプレイヤーのroom_idを使ってルーム情報を取得 ---
            if let roomID = fetchedPlayer?.room_id {
                let fetchedRoom = try await playerRepository.fetchRoomData(byRoomID: roomID)
                self.room = fetchedRoom
            } else {
                // プレイヤーが見つからない、またはルームに所属していない
                self.errorMessage = "ルーム情報が見つかりませんでした。"
            }
            
        } catch {
            self.errorMessage = "データ取得エラー: \(error.localizedDescription)"
        }
        
        self.isLoading = false
    }
    
    func fetchRoomID() -> String {
        let foundID = UserDefaults.standard.string(forKey: "roomID") ?? ""
        return foundID
    }
}
