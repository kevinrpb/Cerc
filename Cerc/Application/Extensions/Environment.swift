//
//  Environment.swift
//  Cerc
//
//  Created by Kevin Romero Peces-Barba on 12/6/21.
//

import SwiftUI

struct TintColorKey: EnvironmentKey {
    static var defaultValue: Color = .teal
}

extension EnvironmentValues {
    var tintColor: Color {
        get { self[TintColorKey.self] }
        set { self[TintColorKey.self] = newValue }
    }
}
