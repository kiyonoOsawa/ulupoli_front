//
//  PlayView.swift
//  ulupoli
//
//  Created by 大澤清乃 on 2025/05/20.
//

import SwiftUI

struct PlayView: View {
    var body: some View {
        ZStack {
            TimerView()
            TimerCircleView()
        }
    }
}

#Preview {
    PlayView()
}
