//
//  Trip.swift
//  Cerc
//
//  Created by Kevin Romero Peces-Barba on 12/6/21.
//

import Foundation

struct Trip {
    struct Transfer {
        let stationID: String

        let arrivalString: String
        var departureStrings: [String]

        let line: String

        mutating func setDepartureStrings(to strings: [String]) {
            self.departureStrings = strings
        }
    }

    let zoneID: String
    let originID: String
    let destinationID: String

    let dateString: String
    let departureString: String
    var arrivalStrings: [String]

    let line: String
    let isCivis: Bool
    let isAccessible: Bool

    var transfers: [Transfer]

    mutating func setArrivalStrings(to strings: [String]) {
        self.arrivalStrings = strings
    }

    func date() -> Date? {
        return Date.from(simpleString: dateString)
    }

    func departure() -> Date? {
        guard let date = self.date() else { return nil }
        return Date.from(date, hourAndMinute: departureString)
    }

    func arrival() -> Date? {
        guard let date = self.date(),
              let arrivalString = arrivalStrings.first else { return nil }
        return Date.from(date, hourAndMinute: arrivalString)
    }

    func duration() -> DateComponents? {
        guard let departure = self.departure(),
              let arrival = self.arrival() else { return nil }

        return Calendar.current.dateComponents([.hour, .minute], from: departure, to: arrival)
    }

    func relativeTimeString() -> String? {
        guard let departure = self.departure() else { return nil }

        return Date.string(for: departure, relativeTo: Date()).capitalized
    }
}

extension Trip.Transfer: Identifiable {
    var id: String {
        "\(stationID)_\(departureStrings.joined(separator: "-"))-\(arrivalString)"
    }
}
extension Trip.Transfer: Codable {}
extension Trip.Transfer: Equatable {}

extension Trip: Identifiable {
    var id: String {
        "\(zoneID)_\(originID)-\(destinationID)_\(dateString)_\(departureString)-\(arrivalStrings.joined(separator: ";"))"
    }
}
extension Trip: Codable {}
extension Trip: Equatable {}
