//
//  CercBadgeModifier.swift
//  Cerc
//
//  Created by Kevin Romero Peces-Barba on 25/9/21.
//

import SwiftUI

struct CercBadgeModifier: ViewModifier {
    let title: String?
    let color: Color
    let size: Double = 20

    func body(content: Content) -> some View {
        if let title = title {
            content
                .overlay(
                    GeometryReader { proxy in
                        Circle()
                            .fill(color)
                            .frame(width: size, height: size)
                            .overlay(Text(title).font(.system(size: size/2)))
                            .offset(
                                x: proxy.frame(in: .local).width - (size / 2),
                                y: -size / 2
                            )
                    }
                )
        } else {
            content
        }
    }
}

extension View {
    func badge(_ title: String?, color: Color) -> some View {
        return self
            .modifier(CercBadgeModifier(title: title, color: color))
    }
}
