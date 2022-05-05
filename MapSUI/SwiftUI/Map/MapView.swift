//
//  ContentView.swift
//  MapSUI
//
//  Created by Mohamed Haddad on 29.04.22.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @ObservedObject var viewModel: MapViewModel
    
    var body: some View {
        Map(
            mapRect: $viewModel.mapRect,
            interactionModes: [.all],
            showsUserLocation: true,
            userTrackingMode: .constant(.none),
            annotationItems: viewModel.annotations) { poi in
                decideAnnotation(poi: poi)
            }
            .introspectMapView(customize: { mapView in
                viewModel.updateAnnotationView(in: mapView)
            })
            .onAppear {
                viewModel.displayAnnotation()
            }
    }
    
    private func decideAnnotation(poi: AnnotationModel) -> some MapAnnotationProtocol {
        if poi.isRegionBound == false {
            return MapAnnotationWrapper(
                MapAnnotation(coordinate: poi.coordinate) {
                    MapAnnotationView(poi: poi, state: viewModel.updateAnnotationState(for: poi))
                        .onTapGesture {
                            viewModel.didSelectAnnotation(poi)
                        }
                }
            )
        } else {
            return MapAnnotationWrapper(
                MapAnnotation(coordinate: poi.coordinate) {
                    Rectangle()
                        .stroke(Color.blue)
                        .frame(width: 20, height: 20)
                }
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(viewModel: MapViewModel())
    }
}
