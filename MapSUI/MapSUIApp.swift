//
//  MapSUIApp.swift
//  MapSUI
//
//  Created by Mohamed Haddad on 29.04.22.
//

import SwiftUI

@main
struct MapSUIApp: App {
    var body: some Scene {
        WindowGroup {
            MapView(viewModel: MapViewModel())
        }
    }
}
