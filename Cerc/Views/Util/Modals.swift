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
