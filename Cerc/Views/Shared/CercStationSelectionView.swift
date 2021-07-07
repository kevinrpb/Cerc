//
//  CercStationSelectionView.swift
//  Cerc
//
//  Created by Kevin Romero Peces-Barba on 12/6/21.
//

import SwiftUI

struct CercStationSelectionView: View {
    @Environment(\.tintColor) var tintColor

    @Binding var stations: [Station]
    let onSelect: (Station) -> Void

    @State private var searchText: String = ""

    private var searchResults: [Station] {
        searchText.isEmpty ? stations : stations.filter {
            $0.name.lowercased().contains(searchText.lowercased())
        }
    }

    private var favourites: [Station] {
//        searchResults.filter { ($0.isFavourite ?? false) }
        searchResults.filter { _ in false } // TODO: Implement some other form of storing favourites...
    }

    private var nonFavourites: [Station] {
//        searchResults.filter { !($0.isFavourite ?? false) }
        searchResults.filter { _ in true } // TODO: Implement some other form of storing favourites...
    }

    var body: some View {
        if stations.isEmpty {
            CercListItem(tint: tintColor) {
                Image(systemName: "exclamationmark.octagon")
                Spacer()
                Text("Hmm... there are no stations! Did you select a zone?")
            }
            .foregroundColor(.red)
        } else {
            CercListItem(tint: tintColor) {
                TextField("Search", text: $searchText)
                Image(systemName: "magnifyingglass")
            }
            .padding(.bottom)
            if !favourites.isEmpty {
                Header("Favourites", image: "star.fill")
                ElementsList(favourites)
            }
            Header("Stations", image: "tram")
            ElementsList(nonFavourites)
        }
    }

    private func Header(_ title: String, image: String) -> some View {
        HStack {
            Label(title, systemImage: image)
                .font(.body.bold())
                .padding(.leading, 6)
            Spacer()
        }
    }

    private func ElementsList(_ stations: [Station]) -> some View {
        ForEach(stations) { station in
            CercListItem(tint: tintColor) {
                Text(station.name)
                Spacer()
//                Button { toggleFavourite(station) } label: {
//                    Image(systemName: station.isFavourite ? "star.fill" : "star")
//                }
                Button {
                    onSelect(station)
                } label: {
                    Text("Select")
                }
                .buttonStyle(CercButtonStyle())
            }
        }
    }

    private func toggleFavourite(_ station: Station) {
//        elements.first { $0.id == station.id }?.isFavourite.toggle()
    }
}
