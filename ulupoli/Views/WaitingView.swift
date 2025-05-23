//
//  WaitingView.swift
//  ulupoli
//
//  Created by 大澤清乃 on 2025/05/20.
//

import SwiftUI

struct WaitingView: View {
    @State var showPlayingSheet: Bool = false
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backColor.ignoresSafeArea()
                VStack {
                    Text("Waiting....")
                        .foregroundColor(.white)
                    
                    NavigationLink {
                        PlayView()
                    } label: {
                        Text("開始")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                }
            }
        }
    }
}

#Preview {
    WaitingView()
}
