import SwiftUI
import Combine

struct WaitingView: View {
    
    @State var showPlayingSheet: Bool = false
//    @State var waitingPlayer: [PlayerModel] = [
//        PlayerModel(name: "user1", roll: Int(), status: Int(), room_id: Int(), card_id: Int(), deleted_at: Date(), created_at: Date(), updated_at: Date()),
//        PlayerModel(name: "user2", roll: Int(), status: Int(), room_id: Int(), card_id: Int(), deleted_at: Date(), created_at: Date(), updated_at: Date()),
//        PlayerModel(name: "user3", roll: Int(), status: Int(), room_id: Int(), card_id: Int(), deleted_at: Date(), created_at: Date(), updated_at: Date())
//    ]
    //開始かどうかの判定
    @State var startStatus: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backColor.ignoresSafeArea()
                VStack(spacing: 16) {
                    Text("Waiting Room")
                        .font(.title)
                        .foregroundColor(.white)
                    
                    VStack {
                        Text("ルームID")
                            .foregroundColor(.white)
                        HStack {
                            Text("AAAAAAA")
                                .font(.title)
                                .foregroundColor(Color.mainColor)
                            Button(action: {
                                
                            }, label: {
                                Image(systemName: "doc.on.doc")
                                    .foregroundColor(.white)
                            })
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.grayColor)
                    .cornerRadius(12)
                    
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
                            ProgressView() // ① デフォルトのアクティビティインジケータ
                                .progressViewStyle(CircularProgressViewStyle(tint: .white)) // ② 色を白に
                                .scaleEffect(1.0) // ③ サイズを大きくする (任意)
                            Text("運営の開始をお待ちください")
                                .padding()
                                .opacity(0.6)
                                
                        }
                        .frame(maxWidth: .infinity)
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
    WaitingView()
}
