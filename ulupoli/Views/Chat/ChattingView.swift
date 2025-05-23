import SwiftUI

struct ChattingView: View {
    
    let message: MessageModel
    let player: ChatPlayerModel
    let isCurrentUser: Bool
    
//    var isCurrentUser: Bool {
//        message.sender.id == currentPlayerId
//    }
    
    var body: some View {
        HStack {
            if isCurrentUser {
                Spacer()
            } else {
                OthersView(imageName: "")
                    .padding(.trailing, 8)
            }
            VStack(alignment: isCurrentUser ? .trailing : .leading, spacing: 4) {
                // 自分以外のメッセージで名前を表示
                if !isCurrentUser {
                    Text(player.name)
                        .font(.caption)
                        .foregroundColor(Color.grayColor)
                        .padding(.leading, 10)
                }
                Text(message.message)
                    .padding(10)
                    .foregroundColor(isCurrentUser ? .white : .white)
                    .background(isCurrentUser ? .blue : Color(uiColor: .systemGray5))
                    .cornerRadius(20)
                
                // 送信日時を表示
                Text(message.createdAt, style: .time)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 5)
            
            if !isCurrentUser {
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}

//#Preview {
//    ChattingView(message: MessageModel(message: "Hi", sender: <#ChatPlayerModel#>), currentPlayerId: <#UUID#>)
//}
