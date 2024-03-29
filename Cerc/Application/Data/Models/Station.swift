//
//  Station.swift
//  Cerc
//
//  Created by Kevin Romero Peces-Barba on 12/6/21.
//

import Foundation

struct Station {
    let id: String
    let name: String
    let zoneID: String
}

extension Station: Identifiable {}
extension Station: Nameable {}
extension Station: Codable {}
extension Station: Equatable {}
