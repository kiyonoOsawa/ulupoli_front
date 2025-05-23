import SwiftUI

struct NFCReadView: View {
    @StateObject private var reader = NFCReader()
    @StateObject private var playerModel = PlayerViewModel()
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Text(reader.tagUID)
                    .padding()
                    .multilineTextAlignment(.center)
                if playerModel.cardIDInput == reader.lastUID {
                    Text("最後に取得したUID: \(playerModel.cardIDInput)")
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
                        playerModel.cardIDInput = reader.lastUID ?? ""
                        playerModel.savePlayer()
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
            playerModel.cardIDInput = newUID
        }
    }
}

#Preview {
    NFCReadView()
}
