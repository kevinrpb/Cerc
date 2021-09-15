//
//  CercTripView.swift
//  Cerc
//
//  Created by Kevin Romero Peces-Barba on 13/6/21.
//

import SwiftUI

struct CercTripItemView: View {
    @Environment(\.tintColor) var tintColor
    
    @EnvironmentObject var controller: CercController

    @State private var isExpanded: Bool = false

    let trip: Trip
    let origin: Station
    let destination: Station

    var body: some View {
        CercListItem(padding: 0, tint: tintColor) {
            VStack {
                HStack {
                    if isExpanded {
                        if let relativeTime = trip.relativeTimeString() {
                            Text("\(relativeTime)")
                        }
                    } else {
                        if let first = trip.departureStrings.first {
                            Text(first)
                                .cercBackground()
                            if trip.departureStrings.count > 1 {
                                Text("(+\(trip.departureStrings.count - 1))")
                            }
                        } else {
                            Text("??:??")
                                .cercBackground()
                        }
                        Text("-")
                        if let first = trip.arrivalStrings.first {
                            Text(first)
                                .cercBackground()
                            if trip.arrivalStrings.count > 1 {
                                Text("(+\(trip.arrivalStrings.count - 1))")
                            }
                        } else {
                            Text("??:??")
                                .cercBackground()
                        }
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .rotationEffect(isExpanded ? .degrees(90) : .degrees(0))
                        .cercBackground()
                }
                .padding(.horizontal)
                if isExpanded {
                    Divider()
                        .background(tintColor.opacity(0.2))
                    VStack {
                        TimesEntry(origin.name, timeStrings: trip.departureStrings, arrival: false)

                        Separator()
                        ForEach(trip.transfers) { transfer in
                            if let station = controller.stations.first(where: { $0.id == transfer.stationID }) {
                                StationEntry(station.name, firstTimesLine: transfer.arrivalStrings, secondTimesLine: transfer.departureStrings)
                            } else {
                                StationEntry("??", firstTimesLine: transfer.arrivalStrings, secondTimesLine: transfer.departureStrings)
                            }
                            Separator()
                        }

                        TimesEntry(destination.name, timeStrings: trip.arrivalStrings, arrival: true)
                    }
                    .padding(.horizontal)
                    if trip.isCivis || trip.isAccessible {
                        Divider()
                            .background(tintColor.opacity(0.2))
                        HStack {
                            if trip.isAccessible {
                                Label("Accessible", image: "wheelchair")
                            }
                            if trip.isCivis {
                                Label("CIVIS", image: "zap")
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.vertical)
        }
        .onTapGesture {
            withAnimation(.interactiveSpring(response: 0.5)) { isExpanded.toggle() }
        }
    }

    private func TimesEntry(_ name: String, timeStrings: [String], arrival: Bool) -> some View {
        VStack {
            HStack {
                Image(systemName: arrival ? "arrow.down.right" : "arrow.up.right")
                    .opacity(0.5)
//                ScrollView(.horizontal) {
                    HStack {
                        ForEach(timeStrings, id: \.self) { timeString in
                            Text(timeString)
                                .cercBackground()
                        }
                        Spacer()
                    }
                    .padding(.bottom, 2)
//                }
                Spacer()
                Text(name)
            }
        }
    }

    private func StationEntry(_ name: String, firstTimesLine: [String], firstIsDeparture: Bool = false, secondTimesLine: [String] = []) -> some View {
        VStack {
            HStack {
                Image(systemName: firstIsDeparture ? "arrow.up.right" : "arrow.down.right")
                    .opacity(0.5)
                HStack {
                    ForEach(firstTimesLine, id: \.self) { timeString in
                        Text(timeString)
                            .cercBackground()
                    }
                    Spacer()
                }
                .padding(.bottom, 2)
                Spacer()
                Text(name)
            }
            if secondTimesLine.count > 0 {
                HStack {
                    Image(systemName: "arrow.up.right")
                        .opacity(0.5)
//                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(secondTimesLine, id: \.self) { timeString in
                                Text(timeString)
                                    .cercBackground()
                            }
                            Spacer()
                        }
                        .padding(.bottom, 2)
//                    }
                }
            }
        }
    }

    private func Separator() -> some View {
        RoundedRectangle(cornerRadius: 1)
            .fill(tintColor.opacity(0.2))
            .frame(width: 50, height: 2)
    }
}

struct CercTripView: View {
    @Environment(\.tintColor) var tintColor

    @EnvironmentObject var controller: CercController

    private var filteredTrips: [Trip] {
        guard let trips = controller.trips else { return [] }
        let now = Date.now
        return trips
            .filter { trip in
                guard let departure = trip.departure() else { return false }
                return departure >= now
            }
            .sorted { tripA, tripB in
                guard let departureA = tripA.departure(),
                      let departureB = tripB.departure() else { return false }
                return departureA <= departureB
            }
    }

    var body: some View {
        switch controller.state {
        case .loadingTrips:
            CercListItem(tint: tintColor) {
                Image(systemName: "network")
                Text("Loading...")
                Spacer()
            }
            .onReceive(controller.$error) { error in
                if error != nil {
                    print("ERROR")
                    controller.state = .normal
                }
            }
        default:
            if let search = controller.tripSearch {
                HStack {
                    Image(systemName: "tram")
                    Text(search.origin.name)
                    Image(systemName: "arrow.right")
                    Text(search.destination.name)
                    Spacer()
                    InverseSearchButton()
                }
                .font(.body.bold())
                .padding(.leading, 6)
                .foregroundColor(tintColor)

                ForEach(filteredTrips) { trip in
                    CercTripItemView(trip: trip, origin: search.origin, destination: search.destination)
                }
            } else {
                CercListItem(tint: tintColor) {
                    Image(systemName: "exclamationmark.octagon")
                    Text("Search for a trip")
                    Spacer()
                }
            }
        }
    }

    private func InverseSearchButton() -> some View {
        Button {
            Task(priority: .userInitiated) {
                controller.reverseStations()
                await controller.startSearch()
            }
        } label: {
            Label("Search other way", systemImage: "arrow.up.arrow.down")
                .labelStyle(.iconOnly)
        }
        .buttonStyle(CercNavButtonStyle(tintColor))
    }
}

struct CercTripView_Previews: PreviewProvider {
    static var previews: some View {
        CercTripView()
    }
}
