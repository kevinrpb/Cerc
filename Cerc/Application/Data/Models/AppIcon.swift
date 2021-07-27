//
//  AppIcon.swift
//  Cerc
//
//  Created by Kevin Romero Peces-Barba on 7/7/21.
//

import Foundation
import UIKit

enum AppIcon: String, CaseIterable {
    case CercIcon
    case CoolSkyIcon

    var image: UIImage {
        return UIImage(named: self.rawValue) ?? UIImage()
    }

    var name: String {
        switch self {
        case .CercIcon:
            return "Default"
        case .CoolSkyIcon:
            return "Cool Sky"
        }
    }
}

extension AppIcon: Identifiable {
    var id: String { self.rawValue }
}
extension AppIcon: Nameable {}
extension AppIcon: Codable {}
