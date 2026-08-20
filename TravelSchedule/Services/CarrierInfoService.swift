//
//  CarrierInfoService.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 13.07.2026.
//

import OpenAPIRuntime
import OpenAPIURLSession

typealias CarrierInfo = Components.Schemas.CarrierResponse

protocol CarrierInfoServiceProtocol {
    func getCarrierInfo(code: String) async throws -> CarrierInfo
}

final class CarrierInfoService: BaseService, CarrierInfoServiceProtocol {
    func getCarrierInfo(code: String) async throws -> CarrierInfo {
        try await networkClient.getCarrierInfo(code: code)
    }
}
