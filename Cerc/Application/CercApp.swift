//
//  CercApp.swift
//  Cerc
//
//  Created by Kevin Romero Peces-Barba on 12/6/21.
//

import SwiftUI

@main
struct CercApp: App {
    private let controller: CercController = CercController()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(controller)
        }
    }
}
