//
//  RoundButton.swift
//  Cerc
//
//  Created by Kevin Romero Peces-Barba on 8/12/19.
//  Copyright © 2019 Kevin Romero Peces-Barba. All rights reserved.
//

import SwiftUI

struct RoundButton<Content: View>: View {

    let action: () -> Void
    let label: () -> Content

    var body: some View {
        Button(action: self.action) {
            self.label()
                .foregroundColor(.white)
                .frame(width: 200, height: 40, alignment: .center)
                .background(RoundButtonBackground())
        }
    }

}

struct RoundButtonBackground: View {

    var body: some View {
        GeometryReader { geometry in
            RoundedRectangle(cornerRadius: geometry.size.height / 2)
                .fill(Color.blue)
        }
    }

}
