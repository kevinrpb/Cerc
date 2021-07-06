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

class CercController: ObservableObject {
    enum State: Int {
        case loading
        case normal
        case settings
        case selectingZone
        case selectingOrigin
        case selectingDestination
        case loadingTrips
        case displayingTrips
    }

    // App state
    @Published var state: State = .loading
    @Published var error: CercError? = nil

    // Settings
    @Published var settings: Settings = Defaults[.settings]

    // Zones and stations data
    @Published var zones: [Zone] = []
    @Published var stations: [Station] = []

    @Published var displayedStations: [Station] = []

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
    private var searchCancellable: AnyCancellable?

    init() {
        $zone
            .sink{ newZone in
                guard let newZone = newZone else { return }
                
                self.displayedStations = self.stations.filter { $0.zoneID == newZone.id }
                Defaults[.selectedZone] = newZone
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
        searchCancellable?.cancel()
    }

    func loadData(force: Bool = false) async {
        guard force || zones.isEmpty || stations.isEmpty else { return }

        state = .loading
        error = nil

        do {
            zones = try await Network.get(.zones)
            stations = try await Network.get(.stations)

            if let selectedZone = Defaults[.selectedZone], zones.contains(selectedZone) {
                zone = selectedZone
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

        tripSearch = .init(zone: zone, origin: origin, destination: destination, date: date, hourStart: hourStart, hourEnd: hourEnd)
        state = .loadingTrips

        // Get the stuff
        do {
            trips = try await Network.get(.trip(search: tripSearch!)) // trip search is init two lines above... should be fine?
            state = .displayingTrips
            error = nil
        } catch let error as CercError {
            self.error = error
        } catch {
            self.error = .generic(error: error)
        }
    }

    func cancelSearch() {
        searchCancellable?.cancel()
        tripSearch = nil
        trips = nil
    }
}

typealias CercState = CercController.State

extension CercState: Identifiable {
    var id: Int { self.rawValue }
}
extension CercState: Equatable {}
