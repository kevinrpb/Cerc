//
//  CercError.swift
//  Cerc
//
//  Created by Kevin Romero Peces-Barba on 12/6/21.
//

import Foundation

enum CercError: Error {
    case zonesNetworkError
    case zonesParsingError

    case stationsNetworkError
    case stationsParsingError

    case tripsNetworkError
    case tripsParsingError
    case tripsNotFoundError

    case formMissingZone
    case formMissingOrigin
    case formMissingDestination

    case defaultError
    case generic(error: Error)

    var description: String {
        switch self {
        case .zonesNetworkError:
            return "There was a network error while loading zones."
        case .zonesParsingError:
            return "There was an error while parsing zones."

        case .stationsNetworkError:
            return "There was a network error while loading stations."
        case .stationsParsingError:
            return "There was an error while parsing stations."

        case .tripsNetworkError:
            return "There was a network error while loading trips."
        case .tripsParsingError:
            return "There was an error while parsing trips."
        case .tripsNotFoundError:
            return "Couldn't find any trips with the selected parameters."

        case .formMissingZone:
            return "You need to select a zone!"
        case .formMissingOrigin:
            return "You need to select an origin station!"
        case .formMissingDestination:
            return "You need to select a destination station!"

        case .generic(let error):
            return error.localizedDescription
        default:
            return "An unknown error ocurred"
        }
    }
}
