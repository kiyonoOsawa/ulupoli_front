//
//  MapView.swift
//  ulupoli
//
//  Created by 大澤清乃 on 2025/05/18.
//

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
    }
}

#Preview {
    MapView()
}
