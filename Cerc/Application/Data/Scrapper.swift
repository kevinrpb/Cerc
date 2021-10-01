//
//  Scrapper.swift
//  Scrapper
//
//  Created by Kevin Romero Peces-Barba on 12/9/21.
//

import Foundation
import SwiftSoup

struct Scrapper {
    static private let decoder: JSONDecoder = .init()

    static func getZones() throws -> [Zone] {
        return Zone.all
    }

    static private func getStations(for zone: Zone) async throws -> [Station] {
        let data = try await Network.get(.stations(zone: zone))

        let html = String(data: data, encoding: .windowsCP1254)! //1254 gets the fewest errors in tildes and such
        let document = try SwiftSoup.parse(html)

        let selectElement = try document.select("select#o")
        let options = try selectElement.select("option")

        let stations: [Station] = try options.array().compactMap { option in
            let id = try option.attr("value")
            let name = try option.text()

            return id != "?"
                ? .init(id: id, name: name, zoneID: zone.id)
                : nil
        }

        return stations
    }

    static func getAllStations() async throws -> [Station] {
        var stations: [Station] = []

        for zone in try Self.getZones() {
            stations.append(contentsOf: try await Self.getStations(for: zone))
        }

        return stations
    }

    static private func simplify(trips: [Trip]) -> [TripSet] {
        var uniqueDepartureTrips: [String: [Trip]] = [:]
        var uniqueArrivalTrips: [String: [Trip]] = [:]

        // Simplify departures for multiple trips
        for trip in trips {
            let transferStations = trip.transfers
//                .map { "\($0.line)-\($0.stationID)" }
                .map { $0.stationID }
                .joined(separator: "-")

            let tripDepartureID = "\(trip.departureString)_\(transferStations)"
            let tripArrivalID = "\(trip.arrivalString)_\(transferStations)"

            if uniqueDepartureTrips[tripDepartureID] != nil {
                uniqueDepartureTrips[tripDepartureID]!.append(trip)
            } else {
                uniqueDepartureTrips[tripDepartureID] = [trip]
            }

            if uniqueArrivalTrips[tripArrivalID] != nil {
                uniqueArrivalTrips[tripArrivalID]!.append(trip)
            } else {
                uniqueArrivalTrips[tripArrivalID] = [trip]
            }
        }

        if uniqueDepartureTrips.count <= uniqueArrivalTrips.count {
            return uniqueDepartureTrips.map { key, trips in
                TripSet(kind: .sameDeparture, trips: trips.sorted())
            }
        } else {
            return uniqueArrivalTrips.map { key, trips in
                TripSet(kind: .sameArrival, trips: trips.sorted())
            }
        }
    }

    static func getTrips(for search: TripSearch) async throws -> [TripSet] {
        let data = try await Network.get(.trip(search: search))

        let result = try Self.decoder.decode(TripSearchResult.self, from: data)

        let trips: [Trip] = (result.horario ?? [])
            .map { trip in
                let transfers: [Trip.Transfer] = (trip.trans ?? []).map { transfer in
                    return .init(
                        stationID: transfer.cdgoEstacion,
                        arrivalString: transfer.horaLlegada,
                        departureString: transfer.horaSalida,
                        line: transfer.linea
                    )
                }

                return .init(
                    zoneID: search.zone.id,
                    originID: search.origin.id,
                    destinationID: search.destination.id,
                    dateString: search.date.simpleDateString,
                    departureString: trip.horaSalida,
                    arrivalString: trip.horaLlegada,
                    line: trip.linea ?? "?",
                    isCivis: (trip.civis ?? "") == "CIVIS",
                    isAccessible: trip.accesible ?? false,
                    transfers: transfers
                )
            }

        let simpleTrips = Self.simplify(trips: trips)
        
        return simpleTrips
    }
}
