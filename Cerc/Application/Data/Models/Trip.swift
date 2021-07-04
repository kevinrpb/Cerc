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
        let departureString: String

        let line: String
    }

    let zoneID: String
    let originID: String
    let destinationID: String

    let dateString: String
    let departureString: String
    let arrivalString: String

    let line: String
    let isCivis: Bool
    let isAccessible: Bool

    let transfers: [Transfer]

    lazy var date: Date? = {
        return Date.from(simpleString: dateString)
    }()

    lazy var departure: Date? = {
        guard let date = date else { return nil }
        return Date.from(date, hourAndMinute: departureString)
    }()

    lazy var arrival: Date? = {
        guard let date = date else { return nil }
        return Date.from(date, hourAndMinute: arrivalString)
    }()

    lazy var duration: DateComponents? = {
        guard let departure = departure,
              let arrival = arrival else { return nil }

        return Calendar.current.dateComponents([.hour, .minute], from: departure, to: arrival)
    }()
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
