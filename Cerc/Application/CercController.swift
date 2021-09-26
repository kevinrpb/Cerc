//
//  CercController.swift
//  Cerc
//
//  Created by Kevin Romero Peces-Barba on 12/6/21.
//

import Combine
import Defaults
import Foundation
import SwiftUI

@MainActor
class CercController: ObservableObject {
    enum State: Int {
        case loading
        case normal
        case settings
        case loadingTrips
        case displayingTrips
    }

    static let global = CercController()

    // App state
    @Published var state: State = .loading
    @Published var error: CercError? = nil

    // Settings
    @Published var settings: Settings = Defaults[.settings]

    // Zones and stations data
    @Published var zones: [Zone] = []
    @Published var stations: [Station] = []

    @Published var displayedStations: [Station] = []
    @Published var favouriteStations: [String] = Defaults[.favouriteStations]

    // Form selections
    @Published var zone: Zone?
    @Published var origin: Station?
    @Published var destination: Station?
    @Published var date: Date = Date.now
    @Published var hourStart: Date = Date.now.startOfDay
    @Published var hourEnd: Date = Date.now.endOfDay

    // Trip stuff
    @Published var tripSearch: TripSearch? = nil
    @Published var trips: [Trip]? = nil

    //
    private var cancellables: Set<AnyCancellable> = .init()

    private init() {
        $zone
            .sink { newZone in
                guard let newZone = newZone else { return }

                self.origin = nil
                self.destination = nil

                self.updateDisplayedStations(zone: newZone, favourites: self.favouriteStations)

                Defaults[.selectedZone] = newZone
            }
            .store(in: &cancellables)

        $favouriteStations
            .sink { newFavourites in
                self.updateDisplayedStations(zone: self.zone, favourites: newFavourites)

                Defaults[.favouriteStations] = newFavourites
            }
            .store(in: &cancellables)

        $settings
            .sink { newSettings in
                Defaults[.settings] = newSettings
            }
            .store(in: &cancellables)
    }

    deinit {
        cancellables.forEach { $0.cancel() }
    }

    func loadData(force: Bool = false) async {
        guard force || zones.isEmpty || stations.isEmpty else { return }

        state = .loading
        error = nil

        do {
            zones = try Scrapper.getZones()
            stations = try await Scrapper.getAllStations()

            if let selectedZone = Defaults[.selectedZone], zones.contains(selectedZone) {
                zone = selectedZone
                updateDisplayedStations(zone: zone, favourites: favouriteStations)
            } else {
                Defaults[.selectedZone] = nil
            }
        } catch let error as CercError {
            self.error = error
        } catch {
            self.error = .generic(error: error)
        }
        
        state = .normal
    }

    private func updateDisplayedStations(zone: Zone?, favourites: [String]) {
        let zoneStations = stations.filter { $0.zoneID == zone?.id }

        var newDisplayedStations: [Station] = []
        newDisplayedStations.append(
            contentsOf: zoneStations.filter { favourites.contains($0.id) }
        )
        newDisplayedStations.append(
            contentsOf: zoneStations.filter { !favourites.contains($0.id) }
        )

        displayedStations = newDisplayedStations
    }

    func reverseStations() {
        let temp = origin
        
        origin = destination
        destination = temp
    }

    func startSearch() async {
        if state == .loadingTrips { cancelSearch() }

        guard let zone = zone else {
            error = .formMissingZone
            return
        }
        guard let origin = origin else {
            error = .formMissingOrigin
            return
        }
        guard let destination = destination else {
            error = .formMissingDestination
            return
        }

        trips = nil
        tripSearch = .init(
            zone: zone,
            origin: origin,
            destination: destination,
            date: date,
            hourStart: hourStart,
            hourEnd: hourEnd
        )
        state = .loadingTrips

        // Get the stuff
        do {
            trips = try await Scrapper.getTrips(for: tripSearch!) // trip search is init two lines above... should be fine?
            state = .displayingTrips
            error = nil
        } catch let error as CercError {
            self.error = error
        } catch {
            self.error = .generic(error: error)
        }
    }

    func cancelSearch() {
        guard state == .loadingTrips else { return }

        trips = nil
        tripSearch = nil
        state = .normal
    }
}

typealias CercState = CercController.State

extension CercState: Identifiable {
    var id: Int { self.rawValue }
}
extension CercState: Equatable {}
