//
//  Network.swift
//  Cerc
//
//  Created by Kevin Romero Peces-Barba on 12/6/21.
//

import Foundation
import SwiftSoup


struct Network {
    static func getZones() throws -> [Zone] { Zone.all }

    static func getStations(for zone: Zone) async throws -> [Station] {
        let url = URL(string: "https://horarios.renfe.com/cer/hjcer300.jsp?NUCLEO=\(zone.id)")!
        let (data, _) = try await URLSession.shared.data(for: .init(url: url))

        let html = String(data: data, encoding: .windowsCP1250)!
        let document = try SwiftSoup.parse(html)
        let select = try document.select("#o")
        let options = try select.select("option")

        let stations: [Station] = try options.array().compactMap { option in
            let id = try option.attr("value")
            let name = try option.text()

            if id == "?" {
                return nil
            }
            else {
                return Station(id: id, name: name, isFavourite: false, zoneID: zone.id)
            }
        }

        return stations
    }

    static func getStations(for zones: [Zone]) async throws -> [Station] {
        var stations: [Station] = []

        for zone in zones {
            stations.append(contentsOf: try await Self.getStations(for: zone))
        }

        return stations
    }

    static func getTrips(for search: TripSearch) async throws -> [Trip] {
        let zoneID = search.zone.id
        let originID = search.origin.id
        let destinationID = search.destination.id
        let dateString = search.date.simpleDateString
        let hourStartString = search.hourStart.hourString
        let hourEndString = search.hourEnd.hourString

        let url = URL(string: "https://horarios.renfe.com/cer/cerHorarios.jsp")!
        let query = [
            "I=s",
            "nucleo=\(zoneID)",
            "i=0",
            "cp=NO",
            "o=\(originID)",
            "d=\(destinationID)",
            "df=\(dateString)",
            "ho=\(hourStartString)",
            "hd=\(hourEndString)",
            "TXTInfo="
        ].joined(separator: "&")

        let request = Self.getPOSTRequest(url, query: query)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard response.mimeType == "text/html" else {
            throw CercError.tripsNetworkError
        }

        let html = String(data: data, encoding: .windowsCP1250)!
        let document = try SwiftSoup.parse(html)

        let table = try document.select("table#tablaHorarios")
        guard let thead = try table.select("thead").first(),
              let tbody = try table.select("tbody").first(),
              let ncolumns = try tbody.select("tr").first()?.children().count else {
            throw CercError.tripsNotFoundError
        }

        // Table head should always have 3 tr inside, but use it as a heuristic for trips with transfer
        let nheaders = try thead.select("tr").count
        // Second heuristic is the text in the second header that should have the transfer station
        let transfer = try? thead.select("tr").array()[1].select("td").first()?.text()
        // Third heuristic is the number of columns in the table, should be either 9 or 10
        if ncolumns == 10 && nheaders == 3 && transfer != nil {
            // Transfer Trip

        } else if ncolumns == 9 {
            // Direct Trip
            let trips = try tbody.select("tr").array().map { tr -> Trip in
                let tds = try tr.select("td").array()

                let line = try tds[0].select("span").first()?.text()

                let departureString = try tds[2].text()
                let arrivalString = try tds[3].text()

                guard let departureHour = Int(departureString.split(separator: ":")[0]),
                      let departureMinute = Int(departureString.split(separator: ":")[1]),
                      let arrivalHour = Int(arrivalString.split(separator: ":")[0]),
                      let arrivalMinute = Int(arrivalString.split(separator: ":")[1]) else {
                    throw CercError.tripsParsingError
                }

                guard let departure = Calendar.current.date(bySettingHour: departureHour, minute: departureMinute, second: 0, of: search.date),
                      let arrival = Calendar.current.date(bySettingHour: arrivalHour, minute: arrivalMinute, second: 0, of: search.date) else {
                    throw CercError.tripsParsingError
                }

                return Trip(
                    origin: search.origin,
                    destination: search.destination,
                    departure: departure,
                    arrival: arrival,
                    line: line,
                    transfer: nil,
                    transferArrival: nil,
                    transferDeparture: nil,
                    transferLine: nil
                )
            }

            return trips
        } else {
            throw CercError.tripsParsingError
        }

        return []
    }

    private static func getPOSTRequest(_ url: URL, query: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", forHTTPHeaderField: "Accept")
        request.setValue("https://horarios.renfe.com", forHTTPHeaderField: "Origin")
        request.setValue("en-GB,en;q=0.9", forHTTPHeaderField: "Accept-Language")
        request.setValue("horarios.renfe.com", forHTTPHeaderField: "Host")
        request.setValue("https://horarios.renfe.com/cer/hjcer300.jsp?NUCLEO=10", forHTTPHeaderField: "Referer")
        request.setValue("gzip, deflate, br", forHTTPHeaderField: "Accept-Encoding")
        request.setValue("keep-alive", forHTTPHeaderField: "Connection")
        request.httpBody = query.data(using: .windowsCP1250)


        // POST /cer/cerHorarios.jsp HTTP/1.1
        // Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
        // Content-Type: application/x-www-form-urlencoded
        // Origin: https://horarios.renfe.com
        // Cookie: JSESSIONID=0000kxcSPdNaINXahH2cAexTJLC:15drhp1bh
        // Content-Length: 68
        // Accept-Language: en-GB,en;q=0.9
        // Host: horarios.renfe.com
        // User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Safari/605.1.15
        // Referer: https://horarios.renfe.com/cer/hjcer300.jsp?NUCLEO=10
        // Accept-Encoding: gzip, deflate, br
        // Connection: keep-alive

        return request
    }
}

