import Foundation
import SwiftUI
import Combine

final class TimerCircleViewModel: ObservableObject {
    @Published var progressValue: CGFloat = 0.0
    
    private var timerCount: CGFloat = 0.0
    private var cancellable: AnyCancellable?
    
    init() {
        startTimer()
    }
    
    private func startTimer() {
        cancellable = Timer.publish(every: 0.1, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                self?.countProgress()
            }
    }
    
    private func countProgress() {
        //ここ全部の180もプレイ時間にする
        if timerCount > 1800 { cancellable?.cancel() }
        timerCount = timerCount + 0.1
        progressValue = timerCount / 1800
    }
}
