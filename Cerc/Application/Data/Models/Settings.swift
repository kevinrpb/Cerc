//
//  Settings.swift
//  Cerc
//
//  Created by Kevin Romero Peces-Barba on 13/6/21.
//

import Defaults
import Foundation
import SwiftUI

struct Settings {
    var tintColorKey: String
    var tintColor: Color {
        if let color = Color.colorForKey[tintColorKey] {
            return color
        } else {
            return Self.base.tintColor
        }
    }

    mutating func setTintColor(_ key: String) {
        tintColorKey = key
    }
}

extension Settings: Codable {}
extension Settings: Defaults.Serializable {}

extension Settings {
    static let base: Settings = .init(tintColorKey: "purple")
}
