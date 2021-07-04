//
//  CercBackgroundModifier.swift
//  Cerc
//
//  Created by Kevin Romero Peces-Barba on 4/7/21.
//

import SwiftUI

struct CercBackgroundModifier: ViewModifier {
    let tint: Color

    init(_ tint: Color = .gray) {
        self.tint = tint
    }

    func body(content: Content) -> some View {
        content
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
//                    .fill(tint.opacity(0.2)) // Would like to do this but I can't for native date pickers...
                    .fill(.gray.opacity(0.2))
            )
    }
}

extension View {
    func cercBackground() -> some View {
        return self.modifier(CercBackgroundModifier())
    }
}
