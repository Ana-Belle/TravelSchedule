//
//  NearestCityService.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 13.07.2026.
//

import OpenAPIRuntime
import OpenAPIURLSession

typealias NearestCity = Components.Schemas.NearestCityResponse

protocol NearestCityServiceProtocol {
    func getNearestCity(lat: Double, lng: Double, distance: Int?) async throws -> NearestCity
}

final class NearestCityService: BaseService, NearestCityServiceProtocol {
    
    func getNearestCity(lat: Double, lng: Double, distance: Int? = nil) async throws -> NearestCity {
        
        let response = try await client.getNearestCity(query: .init(
            apikey: apikey,
            lat: lat,
            lng: lng,
            distance: distance
        ))
        
        return try response.ok.body.json
    }
}
