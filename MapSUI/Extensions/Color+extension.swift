//
//  Color+extension.swift
//  MapSUI
//
//  Created by Mohamed Haddad on 03.05.22.
//

import SwiftUI

extension Color {
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
    
    static var randomOpacity: Color {
        return .purple.opacity(.random(in: 0.2...1))
    }
}
