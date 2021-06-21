//
//  CercListItem.swift
//  Cerc
//
//  Created by Kevin Romero Peces-Barba on 12/6/21.
//

import SwiftUI

struct CercListItem<Content: View>: View {
    let padding: CGFloat?
    let edges: Edge.Set
    let radius: CGFloat
    let tint: Color
    @ViewBuilder let content: () -> Content

    init(
        padding: CGFloat? = nil,
        edges: Edge.Set = .all,
        radius: CGFloat = 15,
        tint: Color = .clear,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.padding = padding
        self.edges = edges
        self.radius = radius
        self.tint = tint
        self.content = content
    }

    var body: some View {
        HStack {
            content()
        }
        .padding(edges, padding)
        .background(
            RoundedRectangle(cornerRadius: radius, style: .continuous)
                .fill(.thinMaterial)
                .background(
                    RoundedRectangle(cornerRadius: radius, style: .continuous)
                        .fill(tint.opacity(0.3))
                )
        )
    }
}

struct CercListItem_Previews: PreviewProvider {
    static var previews: some View {
        CercListItem {
            Text("Hello")
            Spacer()
            Button("World") {}
                .buttonStyle(CercButtonStyle())
        }
        .padding()
    }
}
