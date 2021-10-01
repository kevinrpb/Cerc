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

        var arrivalString: String
        var departureString: String

        let line: String
    }

    let zoneID: String
    let originID: String
    let destinationID: String

    let dateString: String
    var departureString: String
    var arrivalString: String

    let line: String
    let isCivis: Bool
    let isAccessible: Bool

    var transfers: [Transfer]

    func date() -> Date? {
        return Date.from(simpleString: dateString)
    }

    func departure() -> Date? {
        guard let date = date() else { return nil }
        return Date.from(date, hourAndMinute: departureString)
    }

    func arrival() -> Date? {
        guard let date = date() else { return nil }
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
        "\(stationID)_\(departureString)-\(arrivalString)"
    }
}
extension Trip.Transfer: Codable {}
extension Trip.Transfer: Equatable {}

extension Trip: Identifiable {
    var id: String {
        "\(zoneID)_\(originID)-\(destinationID)_\(dateString)_\(departureString)-\(arrivalString)"
    }
}
extension Trip: Codable {}
extension Trip: Equatable {}
extension Trip: Comparable {
    static func < (lhs: Trip, rhs: Trip) -> Bool {
        guard let departureA = lhs.departure(),
              let departureB = rhs.departure(),
              let arrivalA = lhs.arrival(),
              let arrivalB = rhs.arrival() else { return false }

        if departureA == departureB {
            return arrivalA < arrivalB
        } else {
            return departureA < departureB
        }
    }
}

struct TripSet {
    enum Kind: String {
        case sameArrival, sameDeparture
    }

    let kind: Kind
    let trips: [Trip]
}
extension TripSet: Identifiable {
    var id: String {
        trips.map { $0.id }
            .joined(separator: "+")
    }
}
extension TripSet: Comparable {
    static func < (lhs: TripSet, rhs: TripSet) -> Bool {
        guard let firstA = lhs.trips.first,
              let firstB = rhs.trips.first else { return false }

        return firstA < firstB
    }
}
