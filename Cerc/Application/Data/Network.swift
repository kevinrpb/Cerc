//
//  Network.swift
//  Cerc
//
//  Created by Kevin Romero Peces-Barba on 12/6/21.
//

import Foundation

enum Endpoint: Equatable {
    case zones
    case stations(zone: Zone)
    case trip(search: TripSearch)

    var url: URL {
        switch self {
        case .zones:
            return .init(string: "https://horarios.renfe.com/cer/hjcer300.jsp")!
        case .stations(let zone):
            return .init(string: "https://horarios.renfe.com/cer/hjcer300.jsp?NUCLEO=\(zone.id)")!
        case .trip:
            return .init(string: "https://horarios.renfe.com/cer/HorariosServlet")!
        }
    }

    var method: String {
        switch self {
        case .trip:
            return "POST"
        default:
            return "GET"
        }
    }

    var parameters: [String: String] {
        switch self {
        case .trip(let search):
            return [
                "nucleo": search.zone.id,
                "origen": search.origin.id,
                "destino": search.destination.id,
                "fchaViaje": search.date.simpleDateString,
                "horaViajeOrigen": "00",
                "horaViajeLlegada": "26",
                "servicioHorarios": "VTI",
                "validaReglaNegocio": "false",
                "tiempoReal": "false",
                "accesibilidadTrenes": "true",
            ]
        default:
            return [:]
        }
    }
}


struct Network {
    private static let encoder: JSONEncoder = .init()
    
    static func get(_ endpoint: Endpoint) async throws -> Data {
        do {
            var request = URLRequest(url: endpoint.url)

            request.httpMethod = endpoint.method
            if endpoint.method == "POST" {
                request.httpBody = try encoder.encode(endpoint.parameters)
                request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            }

            let (data, _) = try await URLSession.shared.data(for: request)

            return data
        } catch {
            throw CercError.networkError
        }
    }
}

