//
//  Error+Network.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 17.08.2026.
//

import Foundation

extension Error {
    var isNoInternetError: Bool {
        var currentError: Error? = self

        while let error = currentError {
            if let urlError = error as? URLError {
                switch urlError.code {
                case .notConnectedToInternet, .networkConnectionLost, .dataNotAllowed:
                    return true
                default:
                    break
                }
            }

            currentError = (error as NSError).userInfo[NSUnderlyingErrorKey] as? Error
        }

        return false
    }
}
