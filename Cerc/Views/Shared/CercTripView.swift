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
                        // TODO: Calculate
                        Text("Departs in ... minutes")
                    } else {
                        Text(trip.departureString)
                            .cercBackground()
                        Text("-")
                        Text(trip.arrivalString)
                            .cercBackground()
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
                        StationEntry(origin.name, firstTimeString: trip.departureString, firstIsDeparture: true)
                        Separator()
                        ForEach(trip.transfers) { transfer in
                            if let station = controller.stations.first(where: { $0.id == transfer.stationID }) {
                                StationEntry(station.name, firstTimeString: transfer.arrivalString, otherTimeStrings: [transfer.departureString])
                            } else {
                                StationEntry("??", firstTimeString: transfer.arrivalString, otherTimeStrings: [transfer.departureString])
                            }
                            Separator()
                        }
                        StationEntry(destination.name, firstTimeString: trip.arrivalString)
                    }
                    .padding(.horizontal)
                    Divider()
                        .background(tintColor.opacity(0.2))
                    if trip.isCivis || trip.isAccessible {
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

    private func StationEntry(_ name: String, firstTimeString: String, firstIsDeparture: Bool = false, otherTimeStrings: [String] = []) -> some View {
        VStack {
            HStack {
                Image(systemName: firstIsDeparture ? "arrow.up.right" : "arrow.down.right")
                Text(firstTimeString)
                    .cercBackground()
                Spacer()
                Text(name)
            }
            if otherTimeStrings.count > 0 {
                HStack {
                    Image(systemName: "arrow.up.right")
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

    var body: some View {
        switch controller.state {
        case .loadingTrips:
            CercListItem(tint: tintColor) {
                Image(systemName: "network")
                Text("Loading...")
                Spacer()
            }
        default:
            if let trips = controller.trips,
               let search = controller.tripSearch {
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

                ForEach(trips) { trip in
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
