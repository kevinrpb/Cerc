//
//  Search.swift
//  Cerc
//
//  Created by Kevin Romero Peces-Barba on 12/6/21.
//

import Foundation

struct TripSearch {
    let zone: Zone
    let origin: Station
    let destination: Station
    let date: Date
    let hourStart: Date
    let hourEnd: Date
}

extension TripSearch: Identifiable {
    var id: String {
        "\(origin.id)-\(destination.id)_\(date.simpleDateString)_\(hourStart.hourString)-\(hourEnd.hourString)"
    }
}
extension TripSearch: Codable {}
extension TripSearch: Equatable {}
