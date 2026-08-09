//
//  AppErrorState.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 09.08.2026.
//

import Foundation

enum AppErrorState: Equatable {
    case noInternet
    case serverError

    var imageName: String {
        switch self {
        case .noInternet:
            "No Internet"
        case .serverError:
            "Server Error"
        }
    }

    var title: String {
        switch self {
        case .noInternet:
            "Нет интернета"
        case .serverError:
            "Ошибка сервера"
        }
    }

    init(error: Error) {
        if error.isNoInternetError {
            self = .noInternet
        } else {
            self = .serverError
        }
    }
}

private extension Error {
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
