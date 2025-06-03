//
//  PlayerModel.swift
//  ulupoli
//
//  Created by 大澤清乃 on 2025/05/20.
//

import Foundation

struct PlayerModel: Identifiable, Decodable {
    var id: Int?
    var name: String
    var roll: Int
    var status: Int
    var room_id: Int?
    var card_id: Int?
    var deleted_at: Date?
    var created_at: Date
    var updated_at: Date
}
