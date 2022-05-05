//
//  MapViewModel.swift
//  MapSUI
//
//  Created by Mohamed Haddad on 29.04.22.
//

import SwiftUI
import MapKit
import Combine

typealias SearchRegionBounds = (northeastCoordinates: CLLocationCoordinate2D, southwestCoordinates: CLLocationCoordinate2D)

@available(iOS 14.0, *)
final class MapViewModel: ObservableObject {
        
    @Published var mapRect = MKMapRect()
    @Published var regionBoundsCoordinates: SearchRegionBounds?
    private(set) var ignore: Bool = false
    @Published private(set) var ignoreRegionChange: Bool = false
    
    @Published var annotations: [AnnotationModel] = []
    private(set) var selectedAnnotations: Set<AnnotationModel> = []

    
    private var mapCancellables = Set<AnyCancellable>()
    private var annotationsCancellables = Set<AnyCancellable>()
    
    private let spanDelta: Double = 0.01
    private(set) var lastSelectedAnnotation: AnnotationModel?

    init() {
        subscribeToMapRectangleBoundsChange()
        subscribeToRegionBoundsChange()
        subscribeToAnnotationsUpdates()
    }
    
    func subscribeToMapRectangleBoundsChange() {
        $mapRect
            .debounce(for: 1, scheduler: RunLoop.main)
            .sink { [weak self] newMapRectBounds in
                self?.calculateRegionBounds(from: newMapRectBounds)
            }
            .store(in: &mapCancellables)
    }
    
    func subscribeToRegionBoundsChange() {
        $regionBoundsCoordinates
            .sink(receiveValue: { [weak self] bounds in
                guard let regionBounds = bounds else { return }
                self?.updateRegionResults(regionBounds)
            })
            .store(in: &mapCancellables)
    }
    
    private func subscribeToAnnotationsUpdates() {
        $annotations
            .combineLatest($ignoreRegionChange)
            .sink(receiveValue: { [weak self] annotations, ignoreRegionChange in
                guard ignoreRegionChange else { return }
                self?.updateMapRect(for: annotations)
            })
            .store(in: &annotationsCancellables)
    }
    
    // MARK: - Map
    private func updateMapRect(for annotations: [AnnotationModel]) {
        let locationCoordianntesForAnnotations = annotations.map(\.coordinate)
        mapRect = locationCoordianntesForAnnotations.reduce(MKMapRect.null) { rect, coordinate in
            let newRect = makeMapRect(from: coordinate)
            return rect.union(newRect)
        }
    }
    
    private func makeMapRect(from locationCoordinate: CLLocationCoordinate2D) -> MKMapRect{
        let bottomleft = MKMapPoint(
            CLLocationCoordinate2D(
                latitude: locationCoordinate.latitude + spanDelta,
                longitude: locationCoordinate.longitude - spanDelta
            )
        )
        
        let topRight = MKMapPoint(
            CLLocationCoordinate2D(
                latitude: locationCoordinate.latitude - spanDelta,
                longitude: locationCoordinate.longitude + spanDelta
            )
        )
        
        return MKMapRect(
            x: min(bottomleft.x, topRight.x),
            y: min(bottomleft.y, topRight.y),
            width: abs(bottomleft.x - topRight.x),
            height: abs(bottomleft.y - topRight.y)
        )
    }
    
    private func calculateRegionBounds(from mapRect: MKMapRect) {
        var northeastCoordinates = MKMapPoint(x: mapRect.maxX, y: mapRect.origin.y).coordinate
        var southwestCoordinates = MKMapPoint(x: mapRect.origin.x, y: mapRect.maxY).coordinate
        
        if southwestCoordinates.latitude > northeastCoordinates.latitude {
            swap(&southwestCoordinates.latitude, &northeastCoordinates.latitude)
        }
        
        if southwestCoordinates.longitude > northeastCoordinates.longitude {
            swap(&southwestCoordinates.longitude, &northeastCoordinates.longitude)
        }
        
        regionBoundsCoordinates = (northeastCoordinates, southwestCoordinates)
    }
    
    // MARK: - Annotations
    func didSelectAnnotation(_ model: AnnotationModel) {
        print("___ didTapAnnotation \(model.label)!")
        selectedAnnotations.insert(model)
        lastSelectedAnnotation = model
        annotations.shuffle()
    }
    
    
    
    func updateRegionResults(_ bounds: SearchRegionBounds) {
        self.ignoreRegionChange = false

        /// display NE & SW coordinates on map
//        annotations.append(contentsOf: [
//            AnnotationModel(with: "NE", lat: bounds.northeastCoordinates.latitude, lng: bounds.northeastCoordinates.longitude, true),
//            AnnotationModel(with: "SW", lat: bounds.southwestCoordinates.latitude, lng: bounds.southwestCoordinates.longitude, true)
//
//        ])
    }
    
    func updateAnnotationState(for model: AnnotationModel) -> MapAnnotationState {
        guard lastSelectedAnnotation != model else { return .isSelected }
        guard selectedAnnotations.contains(model) == true else { return .neverSelected }
        return .wasSelected
    }
    
    func updateAnnotationView(in mapView: MKMapView) {
        DispatchQueue.main.async { [weak self] in
            guard let annotation = self?.lastSelectedAnnotation else { return }
            
            for mkAnnotation in mapView.annotations {
                let mkAnnotationView = mapView.view(for: mkAnnotation)
                guard mkAnnotation.coordinate != annotation.coordinate else {
                    mkAnnotationView?.layer.zPosition = 5
                    return
                }
                guard self?.selectedAnnotations.contains(where: { $0.coordinate == mkAnnotation.coordinate }) == true else {
                    mkAnnotationView?.layer.zPosition = 1
                    return
                }
                mkAnnotationView?.layer.zPosition = 2
            }
        }
    }
    
    func displayAnnotation()  {
        self.ignoreRegionChange = true

        annotations = [
            AnnotationModel(with: "1", lat: 52.507765, lng: 13.3885261),
            AnnotationModel(with: "2", lat: 52.5086198, lng: 13.3931265),
            AnnotationModel(with: "3", lat: 52.5064475, lng: 13.3954301),
            AnnotationModel(with: "4", lat: 52.5103488, lng: 13.3880743),
            AnnotationModel(with: "5", lat: 52.511653, lng: 13.389325),
            AnnotationModel(with: "6", lat: 52.5097644, lng: 13.3954301)
        ]
    }
}
