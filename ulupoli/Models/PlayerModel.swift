//
//  PlayerModel.swift
//  ulupoli
//
//  Created by 大澤清乃 on 2025/05/20.
//

import Foundation

struct PlayerModel: Identifiable {
    let id = UUID()
    var name: String
    var rool: Int
    var status: Int
    var room_id: String
    var card_id: String
    var deleted_at: Date
    var created_at: Date
    var updated_at: Date
}
