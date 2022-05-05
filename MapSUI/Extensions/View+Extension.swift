//
//  View+Extension.swift
//  MapSUI
//
//  Created by Mohamed Haddad on 05.05.22.
//

import Introspect
import SwiftUI
import MapKit

@available(iOS 14.0, *)
extension View {
    @available(iOS 14.0, *)
    public func introspectMapView(customize: @escaping (MKMapView) -> ()) -> some View {
        introspect(selector: TargetViewSelector.siblingContaining, customize: customize)
    }
}
