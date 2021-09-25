//
//  Color.swift
//  Cerc
//
//  Created by Kevin Romero Peces-Barba on 10/6/21.
//

import SwiftUI

extension Color {
    func lighten(by percentage: Double) -> Color {
        if let lighter = UIColor(self).lighten(by: percentage) {
            return Color(uiColor: lighter)
        } else {
            return self
        }
    }

    func darken(by percentage: Double) -> Color {
        if let darker = UIColor(self).darken(by: percentage) {
            return Color(uiColor: darker)
        } else {
            return self
        }
    }
}

extension Color {
    static let keys: [String] = [
        "black",
        "blue",
        "brown",
        "cyan",
        "gray",
        "indigo",
        "mint",
        "orange",
        "pink",
        "purple",
        "red",
        "teal",
        "yellow"
    ]
    static let colorForKey: [String: Color] = [
        "black": .black,
        "blue": .blue,
        "brown": .brown,
        "cyan": .cyan,
        "gray": .gray,
        "indigo": .indigo,
        "mint": .mint,
        "orange": .orange,
        "pink": .pink,
        "purple": .purple,
        "red": .red,
        "teal": .teal,
        "yellow": .yellow
    ]
}
