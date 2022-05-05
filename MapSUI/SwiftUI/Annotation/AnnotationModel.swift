//
//  AnnotationModel.swift
//  MapSUI
//
//  Created by Mohamed Haddad on 29.04.22.
//

import Foundation
import MapKit
import SwiftUI
import Combine

@available(iOS 14, *)
class AnnotationModel: Identifiable {
    
    let id: UUID = UUID()
    let label: String
    let latitude: Double
    let longitude: Double
    var isRegionBound: Bool = false
    let backgroundColor: Color = Color.random
    
    var coordinate: CLLocationCoordinate2D { CLLocationCoordinate2D(latitude: latitude, longitude: longitude) }
    
    init(with text: String, lat: Double, lng: Double, _ isBounds: Bool = false) {
        label = text
        latitude = lat
        longitude = lng
        isRegionBound = isBounds
    }
}

@available(iOS 14, *)
extension AnnotationModel: Equatable {
    
    static func == (lhs: AnnotationModel, rhs: AnnotationModel) -> Bool {
        return lhs.id == rhs.id &&
        lhs.coordinate == rhs.coordinate
    }
}

@available(iOS 14, *)
extension AnnotationModel: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
