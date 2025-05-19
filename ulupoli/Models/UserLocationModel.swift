import Foundation
import CoreLocation

struct UserLocationModel: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}
