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

// Result
struct TripSearchResult {
    struct Entry {
        struct Transfer {
            let cdgoEstacion: String
            let descEstacion: String
            let horaLlegada: String
            let horaSalida: String
            let linea: String
            let cdgoTren: String
        }

        let linea: String?
        let lineaEstOrigen: String
        let lineaEstDestino: String
        let cdgoTren: String
        let horaSalida: String
        let horaLlegada: String
        let duracion: String
        let civis: String?
        let accesible: Bool?
        let trans: [Transfer]?
    }

    let horario: [Entry]?
}
extension TripSearchResult.Entry.Transfer: Codable {}
extension TripSearchResult.Entry: Codable {}
extension TripSearchResult: Codable {}
