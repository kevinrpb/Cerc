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

    struct Trip: Codable {

        struct Request: Codable {
            let core: String
            let origin: String
            let destination: String
            let date: String

            let originTime: String = "00"
            let destinationTime: String = "26"

            let i: String = "s"
            let cp: String = "NO"
            let TXTInfo: String = ""

            enum CodingKeys: String, CodingKey {
                case core = "nucleo"
                case origin = "o"
                case destination = "d"
                case date = "df"

                case originTime = "ho"
                case destinationTime = "hd"

                case i, cp, TXTInfo
            }
        }

    }

}

typealias CercZone = CercModel.Zone
typealias CercStation = CercModel.Station
typealias CercTrip = CercModel.Trip
typealias CercTripRequest = CercModel.Trip.Request
