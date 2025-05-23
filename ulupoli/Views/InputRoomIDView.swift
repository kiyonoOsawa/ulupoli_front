import SwiftUI

struct InputRoomIDView: View {
    
    @StateObject var viewModel = PlayerViewModel()
    @State var step: step
    
    var body: some View {
        ZStack {
            VStack(spacing: 24) {
                switch step {
                case .inputID:
                    TextField("RoomIDを入力", text: $viewModel.roomIDInput)
                        .padding()
                        .frame(width: 360)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.mainColor, lineWidth: 2)
                        )
                case .inputName:
                    TextField("名前を入力", text: $viewModel.nameInput)
                        .padding()
                        .frame(width: 360)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.mainColor, lineWidth: 2)
                        )
                case .readNFC:
                    Button(action: {
                        print("一旦次")
                    }, label: {
                        Text("完了")
                    })
                }
                Button(action: {
                    print("たっぷ")
                    // roomIDの取得や処理など
                    viewModel.savePlayer()
                }, label: {
                    Text("Next")
                        .padding()
                        .frame(width: 360)
                        .foregroundStyle(.white)
                        .background(Color.main)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.mainColor, lineWidth: 2)
                        )
                })
            }
        }
        .padding()
    }
}

enum step{
    case inputID
    case inputName
    case readNFC
}

#Preview {
    InputRoomIDView(step: .inputID)
}
