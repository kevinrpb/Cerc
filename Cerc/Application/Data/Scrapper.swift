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

        let html = String(data: data, encoding: .windowsCP1251)!
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

    static private func simplify(trips: [Trip]) -> [Trip] {
        var uniqueTrips: [String: [Trip]] = [:]

        // Simplify departures for multiple trips
        for trip in trips {
            let transferStations = trip.transfers
               .map { $0.stationID }
               .joined(separator: "-")

            let tripID = "\(trip.departureString)_\(transferStations)"

            if uniqueTrips[tripID] != nil {
                uniqueTrips[tripID]!.append(trip)
            } else {
                uniqueTrips[tripID] = [trip]
            }
        }

        let trips: [Trip] = uniqueTrips.keys.compactMap { tripSetID in
            let trips = uniqueTrips[tripSetID]!

            var trip = trips.first! // must have otherwise the array wouldn't exist

            for i in 0..<trip.transfers.count {
                var departureStrings: [String] = []
                var arrivalStrings: [String] = []

                for trip in trips {
                    departureStrings.append(contentsOf: trip.transfers[i].departureStrings)
                    arrivalStrings.append(contentsOf: trip.arrivalStrings)
                }

                trip.transfers[i].setDepartureStrings(to: departureStrings)
                trip.setArrivalStrings(to: arrivalStrings)
            }

            return trip
        }

        return trips
    }

    static func getTrips(for search: TripSearch) async throws -> [Trip] {
        let data = try await Network.get(.trip(search: search))

        let result = try Self.decoder.decode(TripSearchResult.self, from: data)

        let trips: [Trip] = (result.horario ?? []).map { trip in
            let transfers: [Trip.Transfer] = (trip.trans ?? []).map { transfer in
                return .init(
                    stationID: transfer.cdgoEstacion,
                    arrivalString: transfer.horaLlegada,
                    departureStrings: [transfer.horaSalida],
                    line: transfer.linea
                )
            }

            return .init(
                zoneID: search.zone.id,
                originID: search.origin.id,
                destinationID: search.destination.id,
                dateString: search.date.simpleDateString,
                departureString: trip.horaSalida,
                arrivalStrings: [trip.horaLlegada],
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
