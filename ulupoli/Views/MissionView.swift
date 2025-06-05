import SwiftUI

struct MissionView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = MissionViewModel()
    
    //どうやってミッションの人数を変化させる？
    
    var body: some View {
        ZStack {
            Color.backColor.ignoresSafeArea()
            VStack(spacing: 20) {
                HStack {
                    Button("閉じる") {
                        dismiss()
                    }
                    .font(.title3)
                    .foregroundColor(.white)
                    .padding()
                    Spacer()
                }
                Spacer()
                Image(systemName: "checkmark.seal")
                    .foregroundColor(Color.main)
                    .font(.system(size: 80))
                Text("\(viewModel.recordedPlayers.count) / \(viewModel.missionPlayerCount) 人")
                    .foregroundColor(.white)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .padding()
                List {
                    ForEach(viewModel.recordedPlayers) { player in
                        HStack(spacing: 40) {
                            Image(systemName: "person.circle")
                                .foregroundColor(Color.main)
                            Text(player.name)
                                .foregroundColor(.white)
                        }
                        .listRowBackground(Color.grayColor)
                        .padding(8)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 300)
                .background(BackGroundView())
                .cornerRadius(20)
                .listStyle(.plain)
                Button("カードを読み込む") {
                    viewModel.startNFCScanning()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white)
                .background(Color.main)
                .cornerRadius(6)
                Spacer()
            }
            .padding()
            // ミッション完了時にアラートを表示
            .alert("ミッション完了！", isPresented: $viewModel.isMissionComplete) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("目標の\(viewModel.missionPlayerCount)人の情報をすべて記録しました。")
            }
        }
    }
}

#Preview {
    MissionView()
}
