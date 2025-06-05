import SwiftUI

struct NFCReadView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject private var reader = NFCReader() // NFCReaderの定義は別途必要
    @StateObject var viewModel = PlayerViewModel() // PlayerViewModelの定義は別途必要
    
    var onFlowCompleteAndDismiss: (Bool) -> Void
    
    var body: some View {
        ZStack {
            Color.grayColor.ignoresSafeArea()
            VStack(spacing: 20) {
                if let uid = reader.lastUID, !uid.isEmpty {
                    Text("スキャンされたUID: \(uid)")
                        .foregroundColor(.white)
                } else {
                    Text(reader.tagUID.isEmpty ? "NFCタグをスキャンしてください" : reader.tagUID) // reader.tagUIDは読み取り中のメッセージ用と仮定
                        .foregroundColor(.white)
                }
                
                if reader.lastUID == nil || reader.lastUID!.isEmpty {
                    Button("UIDを読み取る") {
                        reader.beginScanning()
                    }
                    .padding()
                    .frame(width: 340)
                    .foregroundStyle(.white)
                    // .background(Color.main) // 仮の色定義
                    .background(Color.main)
                    .cornerRadius(6)
                } else {
                    Button("次へ / 完了") { // ボタンのテキストを分かりやすく
                        viewModel.cardIDInput = reader.lastUID ?? ""
                        onFlowCompleteAndDismiss(true)
                        //                        StartView(showWaitingSheet: true)
                        //                        print("ああ\(showInput)")
                        //                        dismiss()          // 画面を閉じる
                        Task {
                            print("えええええ")
                            await viewModel.joinRoom()
                        }
                    }
                    .padding()
                    .frame(width: 340)
                    .foregroundStyle(.white)
                    .background(Color.main) // 読み取り後は色を変えるなど
                    .cornerRadius(6)
                }
            }
            .padding()
        }
        .onChange(of: reader.lastUID) { oldValue, newUID in
            // スキャンされたUIDをViewModelに設定する（任意）
            // この onChange は、UIDがセットされたことを検知するだけにする
            if let uid = newUID, !uid.isEmpty {
                viewModel.cardIDInput = uid
                print("NFC UIDがスキャンされました: \(uid)")
                // ここでは dismiss() を呼び出さない
            }
        }
        // .onAppear { // 最初のスキャンを促す場合
        //     if reader.lastUID == nil || reader.lastUID!.isEmpty {
        //         reader.beginScanning() // 画面表示時に自動でスキャン開始する場合
        //     }
        // }
    }
}
