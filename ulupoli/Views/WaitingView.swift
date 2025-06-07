import SwiftUI
import Combine

struct WaitingView: View {
    
    @State var showPlayingSheet: Bool = false
    //開始かどうかの判定
    @State var startStatus: Bool = false
    @ObservedObject var viewModel: PlayerViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backColor.ignoresSafeArea()
                VStack(spacing: 16) {
                    if viewModel.isLoading {
                        ProgressView("データを読み込んでいます...")
                    } else if let player = viewModel.player {
                        Text("ルームID")
                            .foregroundColor(.white)
                        HStack {
//                            if let room = viewModel.room {
                            Text(viewModel.fetchRoomID())
                                    .font(.title)
                                    .foregroundColor(Color.mainColor)
                                Button(action: {
                                    
                                }, label: {
                                    Image(systemName: "doc.on.doc")
                                        .foregroundColor(.white)
                                })
//                            }
                        }
                        Text(player.name)
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.grayColor)
                            .cornerRadius(12)
                        Spacer()
                        
                    } else if let errorMessage = viewModel.errorMessage {
                        Text("エラー")
                            .font(.largeTitle)
                            .foregroundColor(.red)
                        Text(errorMessage)
                            .multilineTextAlignment(.center)
                    }
//                    Text

                        
                    
                    //                    List {
                    //                        ForEach(waitingPlayer) { player in
                    //                            HStack(spacing: 40) {
                    //                                Image(systemName: "person.circle")
                    //                                    .foregroundColor(Color.main)
                    //                                Text(player.name)
                    //                                    .foregroundColor(.white)
                    //                            }
                    //                            .listRowBackground(Color.grayColor)
                    //                            .padding(8)
                    //                        }
                    //                    }
                    //                    .frame(maxWidth: .infinity)
                    //                    .background(BackGroundView())
                    //                    .cornerRadius(20)
                    //                    .listStyle(.plain)
                    
                    //ここはテスト用！
                    Button("ステータスを変更") {
                        startStatus = true
                    }
                    
                    if startStatus {
                        NavigationLink {
                            PlayView()
                        } label: {
                            Text("開始")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(12)
                        }
                    } else {
                        HStack {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(1.0)
                            Text("運営の開始をお待ちください")
                                .padding()
                                .opacity(0.6)
                        }
                        .frame(maxWidth: .infinity)
                        // ★★★ 最小の高さを指定してレイアウトを安定させる ★★★
                        .frame(minHeight: 48) // 例えばボタンと同じくらいの高さを確保
                        // ★★★ ここまで追加 ★★★
                        .foregroundColor(.white)
                        .background(Color.grayColor)
                        .cornerRadius(12)
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    WaitingView(viewModel: PlayerViewModel())
}
