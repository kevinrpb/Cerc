//
//  CercZoneSelectionView.swift
//  Cerc
//
//  Created by Kevin Romero Peces-Barba on 7/7/21.
//

import SwiftUI

struct CercZoneSelectionView: View {
    @Environment(\.tintColor) var tintColor

    @Binding var zones: [Zone]
    let onSelect: (Zone) -> Void

    var body: some View {
        if zones.isEmpty {
            CercListItem(tint: tintColor) {
                Image(systemName: "exclamationmark.octagon")
                Spacer()
                Text("Oops! There are no zones! Try refreshing?")
            }
            .foregroundColor(.red)
        } else {
            ForEach(zones) { zone in
                CercListItem(tint: tintColor) {
                    Text(zone.name)
                    Spacer()
                    Button {
                        onSelect(zone)
                    } label: {
                        Text("Select")
                    }
                    .buttonStyle(CercButtonStyle())
                }
            }
        }
    }
}
