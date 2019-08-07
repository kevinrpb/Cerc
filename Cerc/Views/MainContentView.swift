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
                    .padding(.top, 40)
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
            Image("CercHeader")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        .frame(height: 48)
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
        PickButton(pickType: .zone, label: "Zone") {
            if self.store.selectedZone == nil {
                self.store.selectZone("10")
            } else {
                self.store.selectZone("-1")
            }
        }
    }

    @ViewBuilder
    func OriginPick() -> some View {
        PickButton(pickType: .origin, label: "Origin") {

        }
    }

    @ViewBuilder
    func DestinationPick() -> some View {
        PickButton(pickType: .destination, label: "Destination") {

        }
    }

}
