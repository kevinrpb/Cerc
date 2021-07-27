//
//  Settings.swift
//  Cerc
//
//  Created by Kevin Romero Peces-Barba on 13/6/21.
//

//import Defaults
import Foundation
import SwiftUI

final class Settings {
    var tintColorKey: String
    var tintColor: Color {
        if let color = Color.colorForKey[tintColorKey] {
            return color
        } else {
            return Self.base.tintColor
        }
    }

    var appIcon: AppIcon

    init(tintColorKey: String, appIcon: AppIcon) {
        self.tintColorKey = tintColorKey
        self.appIcon = appIcon
    }

    func setTintColor(_ toKey: String) {
        tintColorKey = toKey
    }

    func setAppIcon(_ toIcon: AppIcon) {
        UIApplication.shared.setAlternateIconName(toIcon == .CercIcon ? nil : toIcon.rawValue) { [self] error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                appIcon = toIcon
            }
        }
    }
}

extension Settings: Codable {}
//extension Settings: Defaults.Serializable {}

extension Settings {
    static let base: Settings = .init(tintColorKey: "indigo", appIcon: .CercIcon)
}
