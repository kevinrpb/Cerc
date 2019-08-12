//
//  CercModels.swift
//  Cerc
//
//  Created by Kevin Romero Peces-Barba on 8/7/19.
//  Copyright © 2019 Kevin Romero Peces-Barba. All rights reserved.
//

import Foundation

// MARK: - Zone

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

}

typealias CercZone = CercModel.Zone

// MARK: - Station

extension CercModel {

    struct Station: Codable, Nameable {
        let id: String
        let name: String
    }

    typealias StationsRepresentation = [String: [Station]]

}

typealias CercStation = CercModel.Station

// MARK: - Trip

extension CercModel {

    struct Trip: Codable {
        let origin: String
        let destination: String
        let transfer: String?

        let times: [Time]

        init(origin: String, destination: String, transfer: String? = nil, times: [Time]) {
            self.origin = origin
            self.destination = destination
            self.transfer = transfer
            self.times = times
        }
    }

}
typealias CercTrip = CercModel.Trip

// MARK: Request

extension CercModel.Trip {

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
typealias CercTripRequest = CercModel.Trip.Request

// MARK: Step

extension CercModel.Trip {

    struct Time: Codable {
        let line: String
        let departureTime: String
        let arrivalTime: String

        let transferLine: String?
        let transferArrivalTime: String?
        let transferDepartureTime: String?

        let duration: String

        init(line: String,
            departureTime: String,
            arrivalTime: String,
            transferLine: String? = nil,
            transferArrivalTime: String? = nil,
            transferDepartureTime: String? = nil,
            duration: String) {
            self.line = line
            self.departureTime = departureTime
            self.arrivalTime = arrivalTime
            self.transferLine = transferLine
            self.transferArrivalTime = transferArrivalTime
            self.transferDepartureTime = transferDepartureTime
            self.duration = duration
        }
    }
    
}
typealias CercTripTime = CercModel.Trip.Time
