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
        ScrollView {
            VStack {
                TripStationView(kind: .origin)
                TripSegmentView()

                if store.tripTransfer != nil {
                    TripStationView(kind: .transfer)
                    TripSegmentView()
                }

                TripStationView(kind: .destination)

                TripTimesView()
                    .padding(.top, 25)
            }
            .padding()
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

// MARK: - Trip Times

fileprivate struct TripTimesView: View {

    @EnvironmentObject var store: CercStore

    var times: [CercTripTime] {
        return store.loadedTrip?.times ?? []
    }

    var columnWidth: CGFloat {
        return 90
    }

    var body: some View {
        VStack {
            TimesHeader()
            Divider()

            ForEach(0..<times.count) {
                self.TimesRow(timeIndex: $0)
                    .tag($0)
            }
        }
    }

    @ViewBuilder
    func TimesHeader() -> some View {
        HStack {
            Text("Origin").frame(width: columnWidth)

            if store.tripTransfer != nil {
                Text("Transfer").frame(width: 2 * columnWidth)
            }

            Text("Destination").frame(width: columnWidth)
        }
    }

    @ViewBuilder
    func TimesRow(timeIndex: Int) -> some View {
        HStack {
            Text(times[timeIndex].departureTime).frame(width: columnWidth)
                .overlay(times[timeIndex].departureTime != "" ? SegmentOverlay() : nil)

            if store.tripTransfer != nil {
                Text(times[timeIndex].transferArrivalTime ?? "xx.xx").frame(width: columnWidth)
                    .overlay(WaitOverlay())
                Text(times[timeIndex].transferDepartureTime ?? "xx.xx").frame(width: columnWidth)
                    .overlay(SegmentOverlay())
            }

            Text(times[timeIndex].arrivalTime).frame(width: columnWidth)
        }

        if !times.indices.contains(timeIndex + 1) || times[timeIndex + 1].departureTime != "" {
            Divider()
        }
    }

    @ViewBuilder
    func SegmentOverlay() -> some View {
        Image(systemName: "arrow.right")
            .resizable()
            .frame(width: 15, height: 10, alignment: .center)
            .foregroundColor(.gray)
            .offset(x: columnWidth / 2 + 4)
    }

    @ViewBuilder
    func WaitOverlay() -> some View {
        Image(systemName: "clock")
            .resizable()
            .frame(width: 15, height: 15, alignment: .center)
            .foregroundColor(.gray)
            .offset(x: columnWidth / 2 + 4)
    }

}

