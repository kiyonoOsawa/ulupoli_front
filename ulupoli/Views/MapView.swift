import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    
    @StateObject private var locationManager = LocationManager()
    
    let otherUsers: [UserLocationModel] = [
        UserLocationModel(name: "Alice", coordinate: CLLocationCoordinate2D(latitude: 35.64725533757803, longitude: 139.73627972573166)),
        UserLocationModel(name: "Bob", coordinate: CLLocationCoordinate2D(latitude: 35.64725533757803, longitude: 139.73628172573166))
    ]
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $locationManager.region, showsUserLocation: true, annotationItems: otherUsers) { user in
                MapAnnotation(coordinate: user.coordinate) {
                    VStack {
                        Image(systemName: "person.circle.fill")
                            .font(.title)
                            .foregroundColor(.blue)
                        Text(user.name)
                            .font(.title)
                            .foregroundColor(Color.white)
                            .cornerRadius(4)
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            VStack { // ボタンを垂直方向に配置するためのVStackを追加
                Spacer() // ボタンを画面下部に寄せる
                HStack(spacing: 0) { // ボタンを水平方向に配置するためのHStack
                    Spacer() // ボタンを右に寄せる
                    // + ボタンは、地図を拡大します。
                    HStack(spacing: 0) {
                        Button(action: {
                            // locationManager.region にアクセスしてspanを更新
                            let span = MKCoordinateSpan(latitudeDelta: locationManager.region.span.latitudeDelta / 2.0, longitudeDelta: locationManager.region.span.longitudeDelta / 2.0)
                            locationManager.region.span = span
                        }) {
                            Text("+")
                                .font(.system(size: 16))
                        }
                        .padding()
                        .foregroundColor(.gray)
                        .font(.caption)
                        .frame(width: 40, height: 40)
                        Rectangle()
                            .frame(width: 1, height: 40)
                            .foregroundColor(.gray)
                            .opacity(0.8)
//                            .background(.blue)
                        // - ボタンは、地図を縮小します。
                        Button(action: {
                            // locationManager.region にアクセスしてspanを更新
                            let span = MKCoordinateSpan(latitudeDelta: locationManager.region.span.latitudeDelta * 2.0, longitudeDelta: locationManager.region.span.longitudeDelta * 2.0)
                            locationManager.region.span = span
                        }) {
                            Text("-")
                                .font(.system(size: 18))
                        }
                        .padding()
                        .foregroundColor(.gray)
                        .font(.caption)
                        .frame(width: 40, height: 40)
                        //                    .background(.white)
                    }
                    .background(.white)
                    .cornerRadius(8)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20))
                }
                .padding(.bottom, 30) // 下部からの距離
            }
        }
    }
}

#Preview {
    MapView()
}
