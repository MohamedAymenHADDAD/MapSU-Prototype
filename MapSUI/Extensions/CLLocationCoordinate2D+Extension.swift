//
//  CLLocationCoordinate2D+Extension.swift
//  MapSUI
//
//  Created by Mohamed Haddad on 05.05.22.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D: Equatable {
    
    public static func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude &&
        lhs.longitude == rhs.longitude
    }
}
