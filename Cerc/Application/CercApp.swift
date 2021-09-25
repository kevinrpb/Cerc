//
//  CercApp.swift
//  Cerc
//
//  Created by Kevin Romero Peces-Barba on 12/6/21.
//

import SwiftUI

@main
struct CercApp: App {
    private let controller: CercController = .global

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(controller)
        }
//        MARK: Maybe this will be availalbe some day?
//        #if targetEnvironment(macCatalyst)
//        .windowStyle(.hiddenTitleBar)
//        #endif
    }
}
