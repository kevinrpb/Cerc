//
//  MainContentView.swift
//  Cerc
//
//  Created by Kevin Romero Peces-Barba on 7/19/19.
//  Copyright © 2019 Kevin Romero Peces-Barba. All rights reserved.
//

import SwiftUI

struct MainContentView: View {

    @EnvironmentObject var store: CercStore

    // MARK: - Body

    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Header()
                Picks()
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
        }
        .onAppear { self.store.loadAll() }
    }

}

// MARK: - Header

extension MainContentView {

    @ViewBuilder
    func Header() -> some View {
        HStack {
            Image("")
            Text("Cerc")
                .font(.largeTitle)
        }
        .padding(.bottom, 18)
    }

}

// MARK: - Pick Buttons

extension MainContentView {

    @ViewBuilder
    func Picks() -> some View {
        VStack(spacing: 30) {
            ZonePick()
            OriginPick()
            DestinationPick()
        }
    }

    @ViewBuilder
    func ZonePick() -> some View {
        VStack(spacing: 5) {
            Text("Select Zone")
            PickButton(pickType: .zone) {

            }
        }
    }

    @ViewBuilder
    func OriginPick() -> some View {
        VStack(spacing: 5) {
            Text("Select Origin")
            PickButton(pickType: .origin) {

            }
        }
    }

    @ViewBuilder
    func DestinationPick() -> some View {
        VStack(spacing: 5) {
            Text("Select Destination")
            PickButton(pickType: .destination) {

            }
        }
    }

}
