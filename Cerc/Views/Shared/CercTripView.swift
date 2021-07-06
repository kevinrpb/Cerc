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
                        StationEntry(origin.name, departureString: trip.departureString)
                        Separator()
                        ForEach(trip.transfers) { transfer in
                            if let station = controller.stations.first(where: { $0.id == transfer.stationID }) {
                                StationEntry(station.name, arrivalString: transfer.arrivalString, departureString: transfer.departureString)
                            } else {
                                StationEntry("??", arrivalString: transfer.arrivalString, departureString: transfer.departureString)
                            }
                            Separator()
                        }
                        StationEntry(destination.name, arrivalString: trip.arrivalString)
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

    private func StationEntry(_ name: String, arrivalString: String? = nil, departureString: String? = nil) -> some View {
        HStack {
            VStack {
                if let arrivalString = arrivalString {
                    Text(arrivalString)
                        .cercBackground()
                }
                if let departureString = departureString {
                    Text(departureString)
                        .cercBackground()
                }
            }
            Spacer()
            VStack {
                Text(name)
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

//    private var tintColor: Color { controller.settings.tintColor }
    
    var body: some View {
        switch controller.state {
        case .loadingTrips:
            CercListItem(tint: tintColor) {
                Image(systemName: "network")
                Text("Loading...")
                Spacer()
            }
        case .displayingTrips:
            if let trips = controller.trips,
               let origin = controller.tripSearch?.origin,
               let destination = controller.tripSearch?.destination {
                HStack {
                    Image(systemName: "tram")
                    Text(origin.name)
                    Image(systemName: "arrow.right")
                    Text(destination.name)
                    Spacer()
                }
                .font(.body.bold())
                .padding(.leading, 6)
                .foregroundColor(tintColor)

                ForEach(trips) { trip in
                    CercTripItemView(trip: trip, origin: origin, destination: destination)
                }
            } else {
                CercListItem(tint: tintColor) {
                    Image(systemName: "exclamationmark.octagon")
                    Text("There was an error loading trips!")
                    Spacer()
                }
            }
        default:
            CercListItem(tint: tintColor) {
                Image(systemName: "exclamationmark.octagon")
                Text("Search for a trip")
                Spacer()
            }
        }
    }
}

struct CercTripView_Previews: PreviewProvider {
    static var previews: some View {
        CercTripView()
    }
}
