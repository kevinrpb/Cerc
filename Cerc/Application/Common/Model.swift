//
//  CercModels.swift
//  Cerc
//
//  Created by Kevin Romero Peces-Barba on 8/7/19.
//  Copyright © 2019 Kevin Romero Peces-Barba. All rights reserved.
//

import Foundation

struct CercModel {

    struct Zone: Codable, Nameable {
        let id: String
        let name: String
        let mapURL: String

        enum CodingKeys: String, CodingKey {
            case id = "id"
            case name = "name"
            case mapURL = "map"
        }
    }

    struct Station: Codable, Nameable {
        let id: String
        let name: String
    }

    typealias StationsRepresentation = [String: [Station]]

}

typealias CercZone = CercModel.Zone
typealias CercStation = CercModel.Station
