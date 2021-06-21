//
//  CercTripView.swift
//  Cerc
//
//  Created by Kevin Romero Peces-Barba on 13/6/21.
//

import SwiftUI

struct CercTripView: View {
    @EnvironmentObject var controller: CercController
    
    var body: some View {
        switch controller.state {
        case .loadingTrips:
            CercListItem(tint: controller.settings.tintColor) {
                Spacer()
                Text("Loading trips...")
                    .multilineTextAlignment(.center)
                Spacer()
            }
        case .displayingTrips:
            CercListItem(tint: controller.settings.tintColor) {
                Spacer()
                Text("Loading trips...")
                    .multilineTextAlignment(.center)
                Spacer()
            }
        default:
            CercListItem(tint: controller.settings.tintColor) {
                Spacer()
                Text("Search for a trip")
                    .multilineTextAlignment(.center)
                Spacer()
            }
        }
    }
}

struct CercTripView_Previews: PreviewProvider {
    static var previews: some View {
        CercTripView()
    }
}
