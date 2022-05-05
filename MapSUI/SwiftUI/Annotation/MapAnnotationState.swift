//
//  MapAnnotationState.swift
//  MapSUI
//
//  Created by Mohamed Haddad on 05.05.22.
//

import Foundation
import SwiftUI

enum MapAnnotationState: Double {
    case neverSelected = 1
    case wasSelected = 2
    case isSelected = 3
    
    func colors() -> Color {
        switch self {
        case .neverSelected:
            return .randomOpacity
        case .wasSelected:
            return .orange.opacity(0.5)
        case .isSelected:
            return .pink
        }
    }
}
