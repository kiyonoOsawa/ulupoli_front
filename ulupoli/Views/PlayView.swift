import SwiftUI

struct PlayView: View {
    var body: some View {
        ZStack {
            TimerView()
            TimerCircleView()
        }
    }
}

#Preview {
    PlayView()
}
