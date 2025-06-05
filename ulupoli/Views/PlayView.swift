import SwiftUI

struct PlayView: View {
    @State var showMapSheet: Bool = false
    var body: some View {
        NavigationView {
            ZStack {
                Color.backColor.ignoresSafeArea()
                VStack {
                    HStack {
                        Button(action: {
                            print("ガイドラインの画面に飛ばす")
                        }, label:  {
                            Image(systemName: "questionmark.circle.fill")
                                .font(.title)
                                .foregroundColor(Color.main)
                        })
                        .padding()
                        .background(Color.grayColor)
                        .cornerRadius(12)
                        Spacer()
                        Button(action: {
                            showMapSheet = true
                        }, label: {
                            Image(systemName: "map.fill")
                                .font(.title)
                                .foregroundColor(Color.mainColor)
                        })
                        .padding()
                        .background(Color.grayColor)
                        .cornerRadius(12)
                        .sheet(isPresented: $showMapSheet) {
                            MapView()
                        }
                    }
                    Spacer()
                    ZStack {
                        TimerView()
                        TimerCircleView()
                    }
                    Spacer()
                    HStack {
                        Button(action: {
                            print("ミッション画面に")
                        }, label: {
                            HStack {
                                Image(systemName: "checklist")
                                    .font(.title)
                                    .foregroundColor(Color.mainColor)
                                Text("ミッション")
                                    .font(.title3)
                                    .foregroundColor(.white)
                            }
                        })
                        .padding()
                        .background(Color.grayColor)
                        .cornerRadius(12)
                        Spacer()
                        NavigationLink {
                            ChatView()
                        } label: {
                            HStack {
                                Image(systemName: "ellipsis.message.fill")
                                    .font(.title)
                                    .foregroundColor(Color.mainColor)
                                Text(" チャット ")
                                    .font(.title3)
                                    .foregroundColor(.white)
                            }
                        }
                        .padding()
                        .background(Color.grayColor)
                        .cornerRadius(12)
                    }
                }
                .padding()
            }
            .toolbar(.hidden, for: .navigationBar)
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    PlayView()
}
