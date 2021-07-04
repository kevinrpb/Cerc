//
//  CercTripView.swift
//  Cerc
//
//  Created by Kevin Romero Peces-Barba on 13/6/21.
//

import SwiftUI

struct CercTripView: View {
    @EnvironmentObject var controller: CercController
    
    var body: some View {
        switch controller.state {
        case .loadingTrips:
            CercListItem(tint: controller.settings.tintColor) {
                Image(systemName: "network")
                Text("Loading...")
                Spacer()
            }
        case .displayingTrips:
            if let trips = controller.trips,
               let origin = controller.tripSearch?.origin,
               let destination = controller.tripSearch?.destination {
              TripsContent(trips, origin, destination)
            } else {
                CercListItem(tint: controller.settings.tintColor) {
                    Image(systemName: "exclamationmark.octagon")
                    Text("There was an error loading trips!")
                    Spacer()
                }
            }
        default:
            CercListItem(tint: controller.settings.tintColor) {
                Image(systemName: "exclamationmark.octagon")
                Text("Search for a trip")
                Spacer()
            }
        }
    }

    private func TripsContent(_ trips: [Trip], _ origin: Station, _ destination: Station) -> some View {
        ForEach(trips) { trip in
            CercListItem(tint: controller.settings.tintColor) {
                VStack {
                    HStack {
                        Text("In ... minutes")

                        Spacer()

                        if (trip.isCivis) {
//                            Image(systemName: "civis.logo")
                            Image(systemName: "circle.fill")
                        }
                        if (trip.isAccessible) {
//                            Image(systemName: "wheelchair")
                            Image(systemName: "circle.fill")
                        }
                    }
                    StationEntry(origin.name, arrivalString: nil, departureString: trip.departureString)
                    HStack {
                        Spacer()
                        Image(systemName: "arrow.down")
                        Spacer()
                    }
                    ForEach(trip.transfers) { transfer in
                        if let station = controller.stations.first(where: { $0.id == transfer.stationID }) {
                            StationEntry(station.name, arrivalString: transfer.arrivalString, departureString: transfer.departureString)
                        } else {
                            StationEntry("??", arrivalString: transfer.arrivalString, departureString: transfer.departureString)
                        }
                        HStack {
                            Spacer()
                            Image(systemName: "arrow.down")
                            Spacer()
                        }
                    }
                    StationEntry(destination.name, arrivalString: trip.arrivalString, departureString: nil)
                }
            }
        }
    }

    private func StationEntry(_ name: String, arrivalString: String?, departureString: String?) -> some View {
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
}

struct CercTripView_Previews: PreviewProvider {
    static var previews: some View {
        CercTripView()
    }
}
