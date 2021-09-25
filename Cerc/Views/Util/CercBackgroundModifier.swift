//
//  CercBackgroundModifier.swift
//  Cerc
//
//  Created by Kevin Romero Peces-Barba on 4/7/21.
//

import SwiftUI

struct CercBackgroundModifier: ViewModifier {
    let tintColor: Color

    init(_ tintColor: Color = .gray) {
        self.tintColor = tintColor
    }

    func body(content: Content) -> some View {
        content
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
//                    .fill(tintColor.opacity(0.2)) // Would like to do this but I can't for native date pickers...
                    .fill(.gray.opacity(0.2))
            )
    }
}

extension View {
    func cercBackground(_ tintColor: Color = .gray) -> some View {
        return self.modifier(CercBackgroundModifier(tintColor))
    }
}
