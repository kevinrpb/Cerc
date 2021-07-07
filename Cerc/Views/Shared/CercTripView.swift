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
                        Text(trip.departureString)
                            .cercBackground()
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
                        TimesEntry(origin.name, timeStrings: [trip.departureString], arrival: false)
//                        StationEntry(origin.name, firstTimeString: trip.departureString, firstIsDeparture: true)
                        Separator()
                        ForEach(trip.transfers) { transfer in
                            if let station = controller.stations.first(where: { $0.id == transfer.stationID }) {
                                StationEntry(station.name, firstTimeString: transfer.arrivalString, otherTimeStrings: transfer.departureStrings)
                            } else {
                                StationEntry("??", firstTimeString: transfer.arrivalString, otherTimeStrings: transfer.departureStrings)
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

    private func StationEntry(_ name: String, firstTimeString: String, firstIsDeparture: Bool = false, otherTimeStrings: [String] = []) -> some View {
        VStack {
            HStack {
                Image(systemName: firstIsDeparture ? "arrow.up.right" : "arrow.down.right")
                    .opacity(0.5)
                Text(firstTimeString)
                    .cercBackground()
                Spacer()
                Text(name)
            }
            if otherTimeStrings.count > 0 {
                HStack {
                    Image(systemName: "arrow.up.right")
                        .opacity(0.5)
//                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(otherTimeStrings, id: \.self) { timeString in
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
        return trips.filter { trip in
            guard let departure = trip.departure() else { return false }
            return departure >= now
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
        default:
            if let search = controller.tripSearch {
                HStack {
                    Image(systemName: "tram")
                    Text(search.origin.name)
                    Image(systemName: "arrow.right")
                    Text(search.destination.name)
                    Spacer()
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
}

struct CercTripView_Previews: PreviewProvider {
    static var previews: some View {
        CercTripView()
    }
}
