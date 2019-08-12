//
//  SelectionList.swift
//  Cerc
//
//  Created by Kevin Romero Peces-Barba on 8/8/19.
//  Copyright © 2019 Kevin Romero Peces-Barba. All rights reserved.
//

import SwiftUI

fileprivate struct ModalHandler: View {

    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 3, style: .continuous)
                .foregroundColor(.gray)
                .frame(width: 40, height: 6)
                .padding(.vertical)
        }
    }

}

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
        VStack(spacing: 0) {
            ModalHandler()
            
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(items) { item in
                        SelectionListRow(title: item.name) { self.action(item) }
                        .tag(item.id)
                    }
                }
                .padding()
            }
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
        VStack(spacing: 0) {
            ModalHandler()

            ScrollView {
                VStack(spacing: 20) {
                    ForEach(items) { item in
                        SelectionListRow(title: item.name) { self.action(item) }
                        .tag(item.id)
                    }
                }
                .padding(.all)
            }
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
                    .shadow(radius: 2)
                    .animation(.interactiveSpring())
                    .onTapGesture { self.isFavourite.toggle() }
            }
        }
        .padding()
        .background(SelectionListRowBackground(isFavourite: $isFavourite))
        .shadow(radius: 2)
    }

}

fileprivate struct SelectionListRowBackground: View {

    @Binding var isFavourite: Bool

    var body: some View {
        GeometryReader { geometry in
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(self.isFavourite ? Color.red : Color.blue)
                .animation(.interactiveSpring())
        }
    }

}
