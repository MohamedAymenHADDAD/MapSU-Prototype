//
//  CustomMapAnnotation.swift
//  MapSUI
//
//  Created by Mohamed Haddad on 03.05.22.
//

import SwiftUI
import MapKit

struct MapAnnotationWrapper: MapAnnotationProtocol {
    var _annotationData: _MapAnnotationData
    
    init<T: MapAnnotationProtocol>(_ base: T) {
        self._annotationData = base._annotationData
    }
}
