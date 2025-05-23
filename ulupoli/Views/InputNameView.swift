import SwiftUI

struct InputNameView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = PlayerViewModel()
    
    var onCompletion: (Bool) -> Void
    
    var body: some View {
//        NavigationView {
            ZStack {
                Color.grayColor.ignoresSafeArea()
                VStack(spacing: 24) {
                    TextField("名前を入力", text: $viewModel.nameInput)
                        .padding()
                        .frame(width: 360)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.mainColor, lineWidth: 2)
                        )
                    NavigationLink {
                        NFCReadView(viewModel: viewModel, onCompletion: onCompletion)
                    } label: {
                        Text("Next")
                            .padding()
                            .frame(width: 360)
                            .foregroundStyle(.white)
                            .background(Color.main)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.mainColor, lineWidth: 2)
                            )
                    }
                }
            }
        }
//    }
}

//#Preview {
////    InputNameView(onCompletion: Bool())
//}
