//
//  RoomModel.swift
//  ulupoli
//
//  Created by 大澤清乃 on 2025/05/20.
//

import Foundation

struct RoomModel: Identifiable {
    let id = UUID()
    var room_random_id: String
    var deleted_at: Date
    var created_at: Date
    var updated_at: Date
}
