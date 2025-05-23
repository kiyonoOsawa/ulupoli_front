import SwiftUI

struct ChatBox: View {
    
    //テキストを入力するボックスView
//    @FocusState var istyping
//    @Namespace var animation
//    @Binding var isCompleting: Bool
    @Binding var text: String
    
    var sendAction: () -> Void
    
    var body: some View {
        ZStack{
            HStack{
                TextField("メッセージを入力", text: $text)
                    .foregroundStyle(Color(.white))
                    .padding(.leading)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray2))
                    .clipShape(.capsule)
                
                Button(action: sendAction) {
                    Image(systemName: "paperplane")
                        .foregroundStyle(Color.black)
                        .frame(width: 55, height: 55)
                        .background(Color(.white))
                        .clipShape(.capsule)
                        .padding(.vertical)
                }
                .disabled(self.text == "" /*|| isCompleting == true*/)
            }
        }
        .background(Color(Color.backColor))
        .padding()
    }
}
