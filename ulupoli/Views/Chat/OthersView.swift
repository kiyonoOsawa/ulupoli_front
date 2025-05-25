import SwiftUI

struct OthersView: View {
    var imageName: String
    
    var body: some View {
        VStack {
            // アバター画像を円形に表示
            Image(systemName: "person.crop.circle")
                .resizable()
                .frame(width: 30, height: 30)
                .clipShape(Circle())
            
            // AIの名前を表示
            Text("AI")
                .font(.caption) // フォントサイズを小さくするためのオプションです。
                .foregroundColor(Color.grayColor) // テキストの色を黒に設定します。
        }
    }
}

#Preview {
    OthersView(imageName: "person.circle")
}
