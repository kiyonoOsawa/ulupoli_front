import SwiftUI

struct InputRoomIDView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = PlayerViewModel()
    
    @State private var isNameViewActive = false
    
    var onFlowCompleteAndDismiss: (Bool) -> Void

    var body: some View {
        NavigationView {
            ZStack {
                Color.grayColor.ignoresSafeArea()
                //            NavigationStack {
                VStack(spacing: 24) {
                    Text("RoomIDを入力")
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                    TextField("RoomIDを入力", text: $viewModel.roomIDInput)
                        .padding()
                        .foregroundColor(.white)
                        .frame(width: 360)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.mainColor, lineWidth: 2)
                        )
                    ZStack {
                        // (A) これは裏方。UI上には見えず、画面遷移だけを担当
                        NavigationLink(
                            destination: InputNameView(viewModel: viewModel, onFlowCompleteAndDismiss: self.onFlowCompleteAndDismiss),
                            isActive: $isNameViewActive // スイッチと連動
                        ) {
                            EmptyView() // 何も表示しない
                        }
                        
                        // (B) これが表舞台。ユーザーが実際にタップするボタン
                        Button(action: {
                            // --- ここに実行したい処理を書く ---
                            // 1. UserDefaultsに保存
                            UserDefaults.standard.set(viewModel.roomIDInput, forKey: "roomID")
                            print("RoomID: \(viewModel.roomIDInput) を保存しました。")
                            
                            // 2. 処理が終わったら、スイッチをONにして画面遷移を実行
                            isNameViewActive = true
                            
                        }) {
                            // ボタンの見た目
                            Text("Next")
                                .padding()
                                .frame(width: 360)
                                .foregroundStyle(.white)
                                .background(Color.main)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color.mainColor, lineWidth: 2)
                                )
                        }
                    }
                }
            }
            // ここを変更: ナビゲーションバーのタイトルを表示
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("閉じる") {
                        dismiss()
                        onFlowCompleteAndDismiss(false)
                    }
                    .foregroundColor(.white)
                }
            }
            // ここを変更: ナビゲーションバーの背景を表示
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color.grayColor, for: .navigationBar)
        }
        
        .presentationDetents([.fraction(0.5), .large])
        .presentationCornerRadius(20) // シートの角丸を指定（任意）
        
        // ここでシート全体の背景を設定
        .presentationBackground { // ① presentationBackground を使う
            // あなたの望む「ぼかし/影」の色をここで指定
            Color.white.opacity(0.6) // ② 例えば、黒の半透明にする
                .ignoresSafeArea() // 背景がシート全体を覆うように
        }
    }
}

#Preview {
    //    InputRoomIDView(step: .inputID)
    ContentView()
}
