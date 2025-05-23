import SwiftUI

struct NFCReadView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject private var reader = NFCReader()
    @StateObject var viewModel = PlayerViewModel()
    
    var onCompletion: (Bool) -> Void
    
    var body: some View {
        ZStack {
            Color.grayColor.ignoresSafeArea()
                VStack(spacing: 20) {
                    Text(reader.tagUID)
                        .padding()
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    if viewModel.cardIDInput == reader.lastUID {
                        Text("最後に取得したUID: \(viewModel.cardIDInput)")
                            .foregroundColor(.green)
                    }
                    if reader.lastUID == nil {
                        Button("UIDを読み取る") {
                            reader.beginScanning()
                        }
                        .padding()
                        .frame(width: 340)
                        .foregroundStyle(.white)
                        .background(Color.main)
                        .cornerRadius(6)
                    } else {
                        Button("次へ") {
                            // ここでplayerModelにUIDをセットしたり、次の処理へ
                            viewModel.cardIDInput = reader.lastUID ?? ""
                            viewModel.savePlayer()
                        }
                        .padding()
                        .frame(width: 340)
                        .foregroundStyle(.white)
                        .background(Color.main)
                        .cornerRadius(6)
                    }
                }
            .padding()
        }
        .onChange(of: reader.lastUID ?? "") { newUID in
            viewModel.cardIDInput = newUID
            if viewModel.cardIDInput != nil {
                dismiss()
            } else {
                return
            }
        }
    }
}

//#Preview {
//    NFCReadView(onCompletion: false)
//}
