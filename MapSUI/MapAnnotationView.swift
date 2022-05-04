//
//  MapAnnotationView.swift
//  MapSUI
//
//  Created by Mohamed Haddad on 03.05.22.
//

import SwiftUI
import MapKit

struct MapAnnotationView: View {

    let poi: AnnotationModel
    
    var body: some View {
        Circle()
            .fill(poi.isRegionBound ? Color.mint: poi.backgroundColor.opacity(0.7))
            .frame(width: 44, height: 44)
            .overlay {
                Text(poi.label)
                    .foregroundColor(.black)
            }
    }
}

struct MapAnnotationView_Previews: PreviewProvider {
    static var previews: some View {
        MapAnnotationView(poi: AnnotationModel(with: "0", lat: 52.5103488, lng: 13.3880743))
    }
}
