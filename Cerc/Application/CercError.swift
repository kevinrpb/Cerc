//
//  CercError.swift
//  Cerc
//
//  Created by Kevin Romero Peces-Barba on 12/6/21.
//

import Foundation

enum CercError: Error {
    case networkError
    case parsingError

    case tripsNotFoundError

    case formMissingZone
    case formMissingOrigin
    case formMissingDestination

    case defaultError
    case generic(error: Error)

    var description: String {
        switch self {
        case .networkError:
            return "There was a network error while loading data."

        case .parsingError:
            return "There was a an error while parsing the data."

        case .tripsNotFoundError:
            return "Couldn't find any trips with for the specified search."

        case .formMissingZone:
            return "You need to select a zone!"
        case .formMissingOrigin:
            return "You need to select an origin station!"
        case .formMissingDestination:
            return "You need to select a destination station!"

        case .generic(let error):
            print("Got error: \(error)")
            return error.localizedDescription
        default:
            return "An unknown error ocurred"
        }
    }
}
