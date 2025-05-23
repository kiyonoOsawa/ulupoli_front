import Foundation
import MapKit
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 35.6895, longitude: 139.6917), // 東京駅周辺の緯度経度
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
    )
    @Published var userLocation: CLLocation? // ユーザーの現在地を保持するプロパティ
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization() // 使用中にのみ位置情報を使用する許可を求める
        self.locationManager.startUpdatingLocation() // 位置情報の更新を開始
    }
    
    // CLLocationManagerDelegate メソッド
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        // ユーザーの現在地が更新されたら、userLocationを更新
        self.userLocation = location
        
        // 例: 初回のみ現在地に設定し、それ以降はユーザー操作を優先 -> 勝手にカメラが動くのを阻止
        if region.center.latitude == 35.6895 && region.center.longitude == 139.6917 { // 初期値の場合
            region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("位置情報の取得に失敗しました: \(error.localizedDescription)")
    }
}
