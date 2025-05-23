import SwiftUI

struct InputRoomIDView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = PlayerViewModel()
    
    var onCompletion: (Bool) -> Void // Trueなら成功、Falseなら中断など
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.grayColor.ignoresSafeArea()
                //            NavigationStack {
                VStack(spacing: 24) {
                    TextField("RoomIDを入力", text: $viewModel.roomIDInput)
                        .padding()
                        .frame(width: 360)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.mainColor, lineWidth: 2)
                        )
                    NavigationLink {
                        InputNameView(viewModel: viewModel, onCompletion: onCompletion)
                    } label: {
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
            // ここを変更: ナビゲーションバーのタイトルを表示
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("閉じる") {
                        dismiss()
                        onCompletion(false)
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
