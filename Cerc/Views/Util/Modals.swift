//
//  Modals.swift
//  Cerc
//
//  Created by Kevin Romero Peces-Barba on 13/08/2019.
//  Copyright © 2019 Kevin Romero Peces-Barba. All rights reserved.
//

import SwiftUI

struct ModalHandler: View {

    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 3, style: .continuous)
                .foregroundColor(.gray)
                .frame(width: 40, height: 6)
                .padding(.vertical)
        }
//        .background(BlurBackgroundView())
    }

}

struct ModalView<Content: View>: View {

    let content: () -> Content

    init(@ViewBuilder _ content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        VStack(spacing: 0) {
            ModalHandler()

            self.content()
        }
    }

}
