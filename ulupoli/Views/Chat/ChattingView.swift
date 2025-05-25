import SwiftUI

struct ChattingView: View {
    
    let message: MessageModel
    let player: ChatPlayerModel
    let isCurrentUser: Bool
    
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
                        .foregroundColor(.white)
                        .padding(.leading, 10)
                }
                Text(message.message)
                    .padding(10)
                    .foregroundColor(isCurrentUser ? .white : Color.backColor)
                    .background(isCurrentUser ? Color.mainColor : Color(uiColor: .systemGray5))
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
