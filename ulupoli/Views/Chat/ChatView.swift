import SwiftUI
import Combine

@MainActor

struct ChatView: View {
    // ViewModel を @StateObject で生成・保持
    @StateObject private var viewModel: ChatViewModel
    @Environment(\.presentationMode) var presentationMode
    
    // イニシャライザで特定の Service を注入することも可能
    init(viewModel: ChatViewModel = ChatViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            Color(Color.backColor).ignoresSafeArea()
            VStack {
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                }
                // ローディング表示
                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                }
                // チャットメッセージ表示エリア
                ScrollView {
                    ScrollViewReader { proxy in
                        VStack(alignment: .leading) {
                            ForEach(viewModel.messages) { message in
                                ChattingView(
                                    message: message,
                                    player: viewModel.getPlayer(for: message.senderId),
                                    isCurrentUser: message.senderId == viewModel.currentUserId
                                )
                                .id(message.id)
                            }
                        }
                        .onChange(of: viewModel.messages.count) { _ in
                            // 新しいメッセージが追加されたら一番下にスクロール
                            if let lastMessage = viewModel.messages.last {
                                withAnimation { // スムーズにスクロール
                                    proxy.scrollTo(lastMessage.id, anchor: .bottom)
                                }
                            }
                        }
                        .padding(.vertical)
                    }
                }
                .padding(.top)
                .onTapGesture {
                    hideKeyboard()
                }
                Spacer()
                // 入力ボックス
                ChatBox(text: $viewModel.inputText, sendAction: viewModel.sendMessage)
            }
//            .navigationTitle("チャット (Supabase Ready)")
            .toolbarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                // 画面が表示されたらデータをロードし、リスニングを開始
                viewModel.loadInitialData()
                viewModel.startListening()
            }
            .navigationTitle("チャット")
            .toolbarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "arrow.left") // アイコン
                                .font(.caption)
                        }
                        .foregroundColor(Color.backColor)
                        .frame(width: 40, height: 40)
                        .background(Color(.white))
                        .clipShape(.capsule)
                        .padding(.vertical)
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("チャット画面")
                        .font(.headline) // フォントも指定可能
                        .foregroundColor(.white) // ← ここで色を指定！
                }
            }
        }
    }
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

//#Preview {
//    ChatView()
//}
