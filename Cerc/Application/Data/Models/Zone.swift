//
//  Zone.swift
//  Cerc
//
//  Created by Kevin Romero Peces-Barba on 12/6/21.
//

import Defaults
import Foundation

struct Zone {
    let id: String
    let name: String
}

extension Zone: Identifiable {}
extension Zone: Codable {}
extension Zone: Equatable {}
extension Zone: Defaults.Serializable {}

extension Zone {
    static let Asturias       = Zone(id: "20", name: "Asturias")
    static let Barcelona      = Zone(id: "50", name: "Barcelona")
    static let Bilbao         = Zone(id: "60", name: "Bilbao")
    static let Cadiz          = Zone(id: "31", name: "Cádiz")
    static let Madrid         = Zone(id: "10", name: "Madrid")
    static let Malaga         = Zone(id: "32", name: "Málaga")
    static let MurciaAlicante = Zone(id: "41", name: "Murcia/Alicante")
    static let Santander      = Zone(id: "62", name: "Santander")
    static let SanSebastian   = Zone(id: "61", name: "San Sebastián")
    static let Sevilla        = Zone(id: "30", name: "Sevilla")
    static let Valencia       = Zone(id: "40", name: "Valencia")
    static let Zaragoza       = Zone(id: "70", name: "Zaragoza")

    static let all: [Zone] = [
        .Asturias,
        .Barcelona,
        .Bilbao,
        .Cadiz,
        .Madrid,
        .Malaga,
        .MurciaAlicante,
        .Santander,
        .SanSebastian,
        .Sevilla,
        .Valencia,
        .Zaragoza
    ]
}
