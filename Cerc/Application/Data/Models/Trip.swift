//
//  Trip.swift
//  Cerc
//
//  Created by Kevin Romero Peces-Barba on 12/6/21.
//

import Foundation

struct Trip {
    let origin: Station
    let destination: Station
    let departure: Date
    let arrival: Date
    let line: String?

    let transfer: String? // TODO: Convert to Station? idk if it's worth it
    let transferArrival: Date?
    let transferDeparture: Date?
    let transferLine: String?

    var duration: DateComponents {
        return Calendar.current.dateComponents([.hour, .minute], from: departure, to: arrival)
    }
}

extension Trip: Identifiable {
    var id: String {
        "\(line ?? "?")-\(origin.id)-\(destination.id)_\(departure.ISO8601Format())-\(arrival.ISO8601Format())"
    }
}
extension Trip: Codable {}
extension Trip: Equatable {}
