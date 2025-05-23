//
//  WaitingView.swift
//  ulupoli
//
//  Created by 大澤清乃 on 2025/05/20.
//

import SwiftUI

struct WaitingView: View {
    var body: some View {
        ZStack {
            Color.backColor.ignoresSafeArea()
            Text("Waiting....")
                .foregroundColor(.white)
        }
    }
}

#Preview {
    WaitingView()
}
