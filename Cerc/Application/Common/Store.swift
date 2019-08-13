//
//  Store.swift
//  Cerc
//
//  Created by Kevin Romero Peces-Barba on 8/2/19.
//  Copyright © 2019 Kevin Romero Peces-Barba. All rights reserved.
//

import SwiftUI
import Combine

class CercStore: ObservableObject {

    @Published var loading: Bool = false

    @Published var zones: [CercZone] = []
    @Published var stations: CercStationsRepresentation = [:]

    @Published var selectedZone: CercZone? = nil
    @Published var selectedOrigin: CercStation? = nil
    @Published var selectedDestination: CercStation? = nil

    @Published var selectedDate: Date = Date()

    @Published var loadedTrip: CercTrip? = nil
}

extension CercStore {

    func loadAll() {
        loadZones()
        loadStations()
    }

    func loadZones() {
        self.loading = true

        LocalService.shared.load(.zones) { (result: Result<[CercZone], LocalService.LocalError>) in
            switch result {
            case .success(let zones):
                self.zones = zones
            case .failure(let error):
                print(error.localizedDescription)
            }

            self.loading = false
        }
    }

    func loadStations() {
        self.loading = true

        LocalService.shared.load(.stations) { (result: Result<CercStationsRepresentation, LocalService.LocalError>) in
            switch result {
            case .success(let stations):
                self.stations = stations
            case .failure(let error):
                print(error.localizedDescription)
            }

            self.loading = false
        }
    }

}

extension CercStore {

    func selectZone(_ id: String) {
        let matching = self.zones.filter { $0.id == id }

        guard matching.count == 1, let zone = matching.first else {
            self.selectedZone = nil
            return
        }

        self.selectedZone = zone
        self.selectedOrigin = nil
        self.selectedDestination = nil
    }

    func clearZone() {
        self.selectedZone = nil
    }

    func selectOrigin(_ id: String) {
        guard let zone = selectedZone, let zoneStations = stations[zone.id] else {
            self.selectedOrigin = nil
            return
        }

        let matching = zoneStations.filter { $0.id == id }

        guard matching.count == 1, let station = matching.first else {
            self.selectedOrigin = nil
            return
        }

        self.selectedOrigin = station
    }

    func clearOrigin() {
        self.selectedOrigin = nil
    }

    func selectDestination(_ id: String) {
        guard let zone = selectedZone, let zoneStations = stations[zone.id] else {
            self.selectedDestination = nil
            return
        }

        let matching = zoneStations.filter { $0.id == id }

        guard matching.count == 1, let station = matching.first else {
            self.selectedDestination = nil
            return
        }

        self.selectedDestination = station
    }

    func clearDestination() {
        self.selectedDestination = nil
    }

}

extension CercStore {

    func loadTrip(_ completion: (() -> Void)? = nil) {
        self.loading = true

        guard let zone = selectedZone,
            let origin = selectedOrigin,
            let destination = selectedDestination else { self.loading = false; return }

        let request = CercTripRequest(core: zone.id,
                                      origin: origin.id,
                                      destination: destination.id,
                                      date: selectedDate.cercString)

        APIService.shared.load(.trip(request)) { (result: Result<CercTrip, APIService.APIError>) in
            switch result {
            case .success(let trip):
                self.loadedTrip = trip
                completion?()
            case .failure(let error):
                print(error.localizedDescription)
            }

            self.loading = false
        }
    }

    func clearTrip() {
        self.loadedTrip = nil
    }

    var tripOrigin: CercStation? {
        guard let trip = loadedTrip else { return nil }

        return stations[trip.zone]?.first(where: { $0.id == trip.origin })
    }

    var tripDestination: CercStation? {
        guard let trip = loadedTrip else { return nil }

        return stations[trip.zone]?.first(where: { $0.id == trip.destination })
    }

    var tripTransfer: CercStation? {
        guard let trip = loadedTrip else { return nil }

        return stations[trip.zone]?.first(where: { $0.id == trip.transfer })
    }

}
