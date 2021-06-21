//
//  Date.swift
//  Cerc
//
//  Created by Kevin Romero Peces-Barba on 9/6/21.
//

import Foundation

extension Date {
    private static let simpleDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYYMMdd"

        return formatter
    }()

    private static let hourFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"

        return formatter
    }()

    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }

    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }

    var dayRange: ClosedRange<Date> {
        startOfDay...endOfDay
    }

    var simpleDateString: String {
        Self.simpleDateFormatter.string(from: self)
    }

    var hourString: String {
        let str = Self.hourFormatter.string(from: self)
        return str == "23" ? "26" : str // The renfe search uses 26 to denote end of day
    }
}
