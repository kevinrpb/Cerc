//
//  RoundedButton.swift
//  Cerc
//
//  Created by Kevin Romero Peces-Barba on 7/19/19.
//  Copyright © 2019 Kevin Romero Peces-Barba. All rights reserved.
//

import SwiftUI

struct RoundedButton: View {

    let image: String
    let size: CGFloat

    var body: some View {
        Image(systemName: image)
            .font(.title)
            .frame(width: size, height: size)
            .background(Color.white)
            .clipShape(Circle())
            .shadow(radius: 10.0)
    }

}
