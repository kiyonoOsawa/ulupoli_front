import Foundation

// プレイヤー/ユーザー情報 (Supabase の profiles テーブルなどを想定)
struct ChatPlayerModel: Identifiable, Hashable, Codable {
    let id: UUID
    var name: String
    var avatar: String // アバター画像のURLやアセット名
    
    // イニシャライザ
    init(id: UUID = UUID(), name: String, avatar: String) {
        self.id = id
        self.name = name
        self.avatar = avatar
    }
    
    // プレースホルダー/不明なユーザー用
    static var unknown: ChatPlayerModel {
        ChatPlayerModel(name: "不明", avatar: "person.circle")
    }
}
