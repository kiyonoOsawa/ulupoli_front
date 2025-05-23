import SwiftUI

struct PlayView: View {
    var body: some View {
        ZStack {
            TimerView()
            TimerCircleView()
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    PlayView()
}
