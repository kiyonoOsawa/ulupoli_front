import SwiftUI

struct InputRoomIDView: View {
    
    @State var roomID: String = ""
    
    var body: some View {
        ZStack {
            VStack(spacing: 24) {
                TextField("RoomIDを入力", text: $roomID)
                    .padding()
                    .frame(width: 360)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.mainColor, lineWidth: 2)
                    )
                Button(action: {
                    print("たっぷ")
                    // roomIDの取得や処理など
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

#Preview {
    InputRoomIDView()
}
