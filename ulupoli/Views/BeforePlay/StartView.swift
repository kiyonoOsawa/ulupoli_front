import SwiftUI

struct StartView: View {
    @State var showInput: Bool = false
    @State var showHowSheet: Bool = false
    @State var showWaitingSheet: Bool = false
    @State var registerNFC: Bool = false
    @StateObject private var viewModel = PlayerViewModel()
    
    var body: some View {
        ZStack {
            Color.backColor.ignoresSafeArea()
            VStack(spacing: 32) {
                Image("icon")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 200)
                Button("ulupoliをはじめる") {
                    showInput = true
                }
                .frame(width: 300)
                .padding()
                .font(.body)
                .foregroundColor(.main)
                .background(Color.backColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.main, lineWidth: 3)
                )
                .sheet(isPresented: $showInput, onDismiss: {
                        self.showWaitingSheet = true
//                    print("ここで画面を閉じた時の判定を行う")
//                    if registerNFC {
//                        print("NFC読み取りが完了してシートが閉じられました。WaitingViewを表示します。")
////                        showWaitingSheet = false
//                        //こちら↓↓が正しいけど開発中のため↑↑
//                        showWaitingSheet = true
//                        Task {
//                            await viewModel.fetchPlayer()
//                        }
//                    } else {
//                        print("シートが閉じられましたが、NFC読み取りは完了していません。")
////                        showWaitingSheet = true
//                        //こちら↓↓が正しいけど開発中のため↑↑
//                        showWaitingSheet = false
//                    }
                    
                }) {
                    // ▼▼▼ ここから修正 ▼▼▼
                    InputRoomIDView(viewModel: viewModel, onFlowCompleteAndDismiss: { didSucceed in
                        self.showInput = false
                    })
                    // ▲▲▲ ここまで修正 ▲▲▲
//                    InputRoomIDView(onFlowCompleteAndDismiss: { didSucceed in
//                        registerNFC = didSucceed
//                        self.showInput = false
//                    })
                }
                VStack(spacing: 2) {
                    Button("ulupoliの使い方をしる"){
                        showHowSheet = true
                    }
                    .foregroundColor(Color.main)
                    .sheet(isPresented: $showHowSheet) {
                        //ここは仮
                        TimerView()
                    }
                    Rectangle()
                        .frame(width: 180, height: 2)
                        .foregroundColor(Color.main)
                }
            }
        }
        .fullScreenCover(isPresented: $showWaitingSheet) {
            WaitingView(viewModel: viewModel)
        }
    }
}

#Preview {
    StartView()
}
