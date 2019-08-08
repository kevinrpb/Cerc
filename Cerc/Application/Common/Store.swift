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

    @Published var zones: [CercModel.Zone] = []
    @Published var stations: CercModel.StationsRepresentation = [:]

    @Published var selectedZone: CercModel.Zone? = nil
    @Published var selectedOrigin: CercModel.Station? = nil
    @Published var selectedDestination: CercModel.Station? = nil

    @Published var selectedDate: Date = Date()

}

extension CercStore {

    func loadAll() {
        loadZones()
        loadStations()
    }

    func loadZones() {
        LocalService.shared.load(.zones) { (result: Result<[CercModel.Zone], LocalService.LocalError>) in
            switch result {
            case .success(let zones):
                self.zones = zones
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func loadStations() {
        LocalService.shared.load(.stations) { (result: Result<CercModel.StationsRepresentation, LocalService.LocalError>) in
            switch result {
            case .success(let stations):
                self.stations = stations
            case .failure(let error):
                print(error.localizedDescription)
            }
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
