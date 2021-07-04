//
//  CercButtonStyle.swift
//  Cerc
//
//  Created by Kevin Romero Peces-Barba on 12/6/21.
//

import SwiftUI

struct CercButtonStyle: ButtonStyle {
    let tint: Color

    init(_ tint: Color = .gray) {
        self.tint = tint
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
//            .padding(.vertical, 6)
//            .padding(.horizontal, 12)
//            .background(
//                RoundedRectangle(cornerRadius: 10, style: .continuous)
////                    .fill(tint.opacity(0.2)) // Would like to do this but I can't for native date pickers...
//                    .fill(.gray.opacity(0.2))
//            )
            .cercBackground()
            .foregroundColor(configuration.isPressed ? tint.opacity(0.5) : .primary.opacity(0.8))
    }
}

struct CercNavButtonStyle: ButtonStyle {
    let tint: Color

    init(_ tint: Color = .gray) {
        self.tint = tint
    }

    func makeBody(configuration: Configuration) -> some View {
        VStack {
            Spacer()
            configuration.label
                .font(.caption.bold())
                .frame(width: 20, height: 20)
                .padding(6)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(tint.opacity(0.2))
                )
                .foregroundColor(tint.opacity(configuration.isPressed ? 0.5 : 1))
            Spacer()
        }
    }
}
