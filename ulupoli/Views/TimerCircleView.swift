import SwiftUI
struct TimerCircleView: View {
    // ViewModelをStateObjectで宣言してCircleProgressViewModelを監視できるようにする
    @StateObject var viewModel = TimerCircleViewModel()
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color.gray,
                    style: StrokeStyle(
                        lineWidth: 10,
                        lineCap: .round)
                )
                .opacity(0.5)
                .frame(width: 272, height: 272)
            Circle()
                .trim(from: 0.0, to: viewModel.progressValue) 
                .stroke(
                    Color.mainColor,
                    style: StrokeStyle(
                        lineWidth: 10,
                        lineCap: .round)
                )
                .frame(width: 272, height: 272)
                .rotationEffect(Angle(degrees: -90))
        }
    }
}

#Preview {
    TimerCircleView()
}
