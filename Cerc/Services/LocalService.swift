//
//  LocalService.swift
//  Cerc
//
//  Created by Kevin Romero Peces-Barba on 7/19/19.
//  Copyright © 2019 Kevin Romero Peces-Barba. All rights reserved.
//

import Foundation

class LocalService {

    public static let shared = LocalService()
    private let decoder = JSONDecoder()

    enum LocalResource: String {
        case zones, stations
    }

    enum LocalError: Error {
        case fileError(error: Error?)
        case decodingError(error: Error)
    }

    func load<T: Codable>(_ resource: LocalResource, _ completionHandler: @escaping (Result<T, LocalError>) -> Void) {
        guard let path = Bundle.main.path(forResource: resource.rawValue, ofType: "json") else { return }
        let url = URL(fileURLWithPath: path)

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(.failure(.fileError(error: nil)))
                }
                return
            }

            guard error == nil else {
                DispatchQueue.main.async {
                    completionHandler(.failure(.fileError(error: error)))
                }
                return
            }

            do {
                let object = try self.decoder.decode(T.self, from: data)

                DispatchQueue.main.async {
                    completionHandler(.success(object))
                }
            } catch let error {
                DispatchQueue.main.async {
                    completionHandler(.failure(.decodingError(error: error)))
                }
            }
        }.resume()
    }

}
