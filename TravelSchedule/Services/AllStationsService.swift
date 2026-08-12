//
//  AllStationsService.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 13.07.2026.
//

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias AllStations = Components.Schemas.AllStationsResponse

protocol AllStationsServiceProtocol {
    func getAllStations() async throws -> AllStations
}

final class AllStationsService: BaseService, AllStationsServiceProtocol {
    
    private let decoder = JSONDecoder()
    
    func getAllStations() async throws -> AllStations {
        let response = try await client.getAllStations(query: .init(apikey: apikey))
        
        let responseBody = try response.ok.body.html
        
        let limit = 50 * 1024 * 1024
        let fullData = try await Data(collecting: responseBody, upTo: limit)
        
        let allStations = try decoder.decode(AllStations.self, from: fullData)
        
        return allStations
    }
}
