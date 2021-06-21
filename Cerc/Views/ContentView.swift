//
//  ContentView.swift
//  Cerc
//
//  Created by Kevin Romero Peces-Barba on 13/6/21.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    @EnvironmentObject var controller: CercController

    var body: some View {
        NavigationView {
            CompactLayoutView()
                .environmentObject(controller)
                .environment(\.horizontalSizeClass, horizontalSizeClass)
            if horizontalSizeClass == .regular {
                ScrollView {
                    VStack {
                        CercTripView()
                            .environmentObject(controller)
                    }
                    .padding()
                }
                .background(controller.settings.tintColor.opacity(0.1))
                .navigationTitle("Trip")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
