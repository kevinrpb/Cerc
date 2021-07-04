//
//  Network.swift
//  Cerc
//
//  Created by Kevin Romero Peces-Barba on 12/6/21.
//

import Foundation

enum Endpoint: Equatable {
    case zones
    case stations
    case trip(search: TripSearch)

    #if DEBUG
    static let API_URL: URL = URL(string: "https://localhost:3000")!
    #else
    static let API_URL: URL = URL(string: "https://cerc-api.glitch.me")!
    #endif

    var url: URL {
        switch self {
        case .zones:
            return Self.API_URL
                .appendingPathComponent("zones")
        case .stations:
            return Self.API_URL
                .appendingPathComponent("stations")
        case .trip(let search):
            return Self.API_URL
                .appendingPathComponent("zone=\(search.zone.id)")
                .appendingPathComponent("trips")
                .appendingPathComponent("from=\(search.origin.id)")
                .appendingPathComponent("to=\(search.destination.id)")
                .appendingPathComponent("on=\(search.date.simpleDateString)")
        }
    }
}


struct Network {
    private static let decoder: JSONDecoder = .init()

    static func get<Result>(_ endpoint: Endpoint) async throws -> [Result] where Result: Codable {
        do {
            let (data, _) = try await URLSession.shared.data(from: endpoint.url)

            return try Self.decoder.decode([Result].self, from: data)
        } catch let DecodingError.dataCorrupted(context) {
            print(context)
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.typeMismatch(type, context)  {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch {
            throw CercError.networkError
        }

        throw CercError.parsingError
    }
}

