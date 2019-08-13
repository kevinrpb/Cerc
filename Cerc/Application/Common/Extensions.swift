//
//  Extensions.swift
//  Cerc
//
//  Created by Kevin Romero Peces-Barba on 7/19/19.
//  Copyright © 2019 Kevin Romero Peces-Barba. All rights reserved.
//

import Foundation
import SwiftUI

// MARK: - Date

extension Date {

    var simpleString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd / MM / yyyy"
        return formatter.string(from: self)
    }

    var cercString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter.string(from: self)
    }

}

// MARK: - Encodables

extension Encodable {

    var dictionary: [String: Any]? {
      guard let data = try? JSONEncoder().encode(self) else { return nil }
      return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }

}
