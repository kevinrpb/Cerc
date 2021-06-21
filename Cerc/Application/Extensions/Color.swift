//
//  Color.swift
//  Cerc
//
//  Created by Kevin Romero Peces-Barba on 10/6/21.
//

import Defaults
import SwiftUI

extension Color {
    public static let CercGradient1: Color = .init(red: 251/255, green: 194/255, blue: 235/255)
    public static let CercGradient2: Color = .init(red: 166/255, green: 193/255, blue: 238/255)
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
