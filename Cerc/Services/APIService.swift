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
                case .trip(let request):
                    object = try self.parseTrip(from: data, request: request)
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

    private func parseTrip(from data: Data, request: CercTripRequest) throws -> CercTrip {
        let html = String(data: data, encoding: .isoLatin1)!

        let document: Document = try SwiftSoup.parse(html)

        let transfer = try? document.select("span#codigoOrigenTransbordo").text()
        let rows = try document.select("table tr").filter { $0.hasClass("par") || $0.hasClass("impar") }

        return (transfer != nil && transfer != "") ?
            try parseMultiTrip(rows, request: request, transfer: transfer!) :
            try parseSingleTrip(rows, request: request)
    }

    private func parseSingleTrip(_ rows: [Element], request: CercTripRequest) throws -> CercTrip {
        let times: [CercTripTime] = try rows.map {
            let columns = try $0.select("td").filter { try $0.select("span.rojo4").first() == nil }

            let line = try columns[0].select("span").first()?.text() ?? ""
            let departureTime = try columns[1].text()
            let arrivalTime = try columns[2].text()
            let duration = try columns[3].select("span").first()?.text() ?? ""

            return CercTripTime(line: line,
                                departureTime: departureTime,
                                arrivalTime: arrivalTime,
                                duration: duration)
        }

        return CercTrip(zone: request.core,
                        origin: request.origin,
                        destination: request.destination,
                        times: times)
    }

    private func parseMultiTrip(_ rows: [Element], request: CercTripRequest, transfer: String) throws -> CercTrip {
        let times: [CercTripTime] = try rows.map {
            let columns = try $0.select("td").filter { try $0.select("span.rojo4").first() == nil }

            let line = try columns[0].select("span").first()?.text() ?? ""
            let departureTime = try columns[1].text()
            let arrivalTime = try columns[5].text()
            let transferLine = try columns[4].select("span").first()?.text()
            let transferArrivalTime = try columns[2].text()
            let transferDepartureTime = try columns[3].text()
            let duration = try columns[6].select("span").first()?.text() ?? ""

            return CercTripTime(line: line,
                                departureTime: departureTime,
                                arrivalTime: arrivalTime,
                                transferLine: transferLine,
                                transferArrivalTime: transferArrivalTime,
                                transferDepartureTime: transferDepartureTime,
                                duration: duration)
        }

        return CercTrip(zone: request.core,
                        origin: request.origin,
                        destination: request.destination,
                        transfer: transfer,
                        times: times)
    }

}
