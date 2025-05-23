import SwiftUI

struct TimerView: View {
    //180のところをプレイ時間に変える
    @State private var timeInterval: TimeInterval = 1800
    @State var isShowAlert = false
    
    private let formatter = TimerFormatter()
    private let timer = Timer.publish(every: 1.0, on: .main, in: .common)
        .autoconnect()
    
    var body: some View {
        Text(NSNumber(value: timeInterval), formatter: formatter)
            .font(.system(size: 32))
            .foregroundStyle(.white)
            .onReceive(timer) { _ in
                timeInterval -= 1.0
                timeInterval = max(self.timeInterval, 0)
            }
    }
}

#Preview {
    TimerView()
}
