//
//  String.swift
//  String
//
//  Created by Kevin Romero Peces-Barba on 27/7/21.
//

import Foundation

extension String: Identifiable {
    public var id: String { self }
}
extension String: Nameable {
    var name: String { self }
}
