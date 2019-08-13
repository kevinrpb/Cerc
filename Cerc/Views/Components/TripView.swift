//
//  TripView.swift
//  Cerc
//
//  Created by Kevin Romero Peces-Barba on 13/08/2019.
//  Copyright © 2019 Kevin Romero Peces-Barba. All rights reserved.
//

import SwiftUI

struct TripView: View {

    @EnvironmentObject var store: CercStore

    var body: some View {
        VStack(spacing: 0) {
            ModalHandler()
            
            ScrollView {
                VStack {
                    TripStationView(kind: .origin)
                    TripSegmentView()

                    if store.tripTransfer != nil {
                        TripStationView(kind: .transfer)
                        TripSegmentView()
                    }

                    TripStationView(kind: .destination)
                }
                .padding()
            }
        }
    }

}

// MARK: - Stations

fileprivate struct TripStationView: View {

    enum Kind {
        case none, origin, transfer, destination
    }

    @EnvironmentObject var store: CercStore

    @State var kind: Kind = .none

    var title: String {
        switch kind {
        case .none: return ""
        case .origin: return store.tripOrigin?.name ?? ""
        case .destination: return store.tripDestination?.name ?? ""
        case .transfer: return store.tripTransfer?.name ?? ""
        }
    }

    var body: some View {
        HStack {
            Text(self.title)
                .font(.title)
                .foregroundColor(.white)
            Spacer()
        }
        .padding()
        .background(TripStationViewBackground(kind: $kind))
        .shadow(radius: 2)
    }

}

fileprivate struct TripStationViewBackground: View {

    @Binding var kind: TripStationView.Kind

    var fillColor: Color {
        switch kind {
        case .none: return .clear
        case .origin: return .blue
        case .destination: return .blue
        case .transfer: return .blue
        }
    }

    var body: some View {
        GeometryReader { geometry in
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(self.fillColor)
                .animation(.interactiveSpring())
        }
    }

}

// MARK: - Trip Segments

fileprivate struct TripSegmentView: View {

    var body: some View {
        HStack {
            Spacer()

            Image(systemName: "arrow.down")
                .resizable()
                .font(.caption)
                .frame(width: 36, height: 36)
                .padding(.vertical, 10)

            Spacer()
        }
    }

}
