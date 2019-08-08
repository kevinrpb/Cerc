//
//  SelectionList.swift
//  Cerc
//
//  Created by Kevin Romero Peces-Barba on 8/8/19.
//  Copyright © 2019 Kevin Romero Peces-Barba. All rights reserved.
//

import SwiftUI

// MARK: - Types

enum SelectionType {
    case zone
    case origin
    case destination
}

// MARK: - Lists

struct ZoneSelectionList: View {

    @EnvironmentObject var store: CercStore

    let action: (CercZone) -> Void

    var items: [CercZone] {
        return store.zones
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                ForEach(items) { item in
                    SelectionListRow(title: item.name) {
                        self.action(item)
                    }
                    .tag(item.id)
                }
            }
            .padding(.all)
        }
    }

}

struct StationSelectionList: View {

    @EnvironmentObject var store: CercStore

    let action: (CercStation) -> Void

    var items: [CercStation] {
        return store.stations[store.selectedZone?.id ?? ""] ?? []
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(items) { item in
                    SelectionListRow(title: item.name) {
                        self.action(item)
                    }
                    .tag(item.id)
                }
            }
            .padding(.all)
        }
    }

}

// MARK: - Rows

fileprivate struct SelectionListRow: View {

    @State var isFavourite: Bool = false

    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: { self.action() }) {
            HStack {
                Text(title)
                    .font(.title)
                    .foregroundColor(.white)

                Spacer()

                Image(systemName: self.isFavourite ? "star.fill" : "star")
                    .foregroundColor(self.isFavourite ? .yellow : .black)
                    .animation(.interactiveSpring())
                    .onTapGesture { self.isFavourite.toggle() }
            }
        }
        .padding()
        .background(SelectionListRowBackground())
        .shadow(radius: 2)
    }

}

fileprivate struct SelectionListRowBackground: View {

    var body: some View {
        GeometryReader { geometry in
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(Color.blue)
        }
    }

}
