//
//  CopyrightService.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 12.07.2026.
//

import OpenAPIRuntime
import OpenAPIURLSession

typealias Copyright = Components.Schemas.CopyrightResponse

protocol CopyrightServiceProtocol {
    func getCopyright() async throws -> Copyright
}

final class CopyrightService: BaseService, CopyrightServiceProtocol {
    func getCopyright() async throws -> Copyright {
        try await networkClient.getCopyright()
    }
}
