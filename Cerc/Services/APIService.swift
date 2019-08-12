//
//  APIService.swift
//  Cerc
//
//  Created by Kevin Romero Peces-Barba on 8/12/19.
//  Copyright © 2019 Kevin Romero Peces-Barba. All rights reserved.
//

import Foundation
import SwiftSoup

class APIService {

    public static let shared = APIService()
    private let decoder = JSONDecoder()

    enum APIResource {
        case trip(_ request: CercModel.Trip.Request)

        var url: String {
            switch self {
            case .trip:
                return "http://horarios.renfe.com/cer/hjcer310.jsp?"
            }
        }

        var requestParams: [String: Any]? {
            switch self {
            case .trip(let request):
                return request.dictionary
            }
        }
    }

    enum APIError: Error {
        case networkError(error: Error?)
        case fileError(error: Error?)
        case decodingError(error: Error)
    }

    func load<T: Codable>(_ resource: APIResource, _ completionHandler: @escaping (Result<T, APIError>) -> Void) {
        var components = URLComponents(string: resource.url)
        let queryItems = resource.requestParams?.map { URLQueryItem(name: $0, value: "\($1)") } ?? []

        components?.queryItems = queryItems

        guard let url = components?.url else { return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(.failure(.fileError(error: nil)))
                }
                return
            }

            guard error == nil else {
                DispatchQueue.main.async {
                    completionHandler(.failure(.networkError(error: error)))
                }
                return
            }

            do {
                var object: Any

                switch resource {
                case .trip:
                     object = try self.parseTrip(from: data)
                }

                DispatchQueue.main.async {
                    completionHandler(.success(object as! T))
                }
            } catch let error {
                DispatchQueue.main.async {
                    completionHandler(.failure(.decodingError(error: error)))
                }
            }
        }.resume()
    }

}

// MARK: - Cercanias Trip Parsing

extension APIService {

    private func parseTrip(from data: Data) throws -> CercTrip {
        let html = String(data: data, encoding: .isoLatin1)!

        let document: Document = try SwiftSoup.parse(html)

        let rows = try document.select("table tr")

        let hasTransfer = try rows.filter {
            let cols = try $0.select("td")
            return !$0.hasClass("par") && !$0.hasClass("impar") && cols.count < 2
        }.count > 0

        return hasTransfer ? try parseMultiTrip(rows) : try parseSingleTrip(rows)
    }

    private func parseSingleTrip(_ rows: Elements) throws -> CercTrip {
        print(">> NO TRANSFER")

        return CercTrip()
    }

    private func parseMultiTrip(_ rows: Elements) throws -> CercTrip {
        print(">> TRANSFER")

        return CercTrip()
    }

}
