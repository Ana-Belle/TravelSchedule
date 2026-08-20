//
//  NetworkClient.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 20.08.2026.
//

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

actor NetworkClient {
    private let client: Client
    private let apikey: String
    private let allStationsDecoder = JSONDecoder()
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getAllStations() async throws -> AllStations {
        let response = try await client.getAllStations(query: .init(apikey: apikey))
        let responseBody = try response.ok.body.html
        let limit = 50 * 1024 * 1024
        let fullData = try await Data(collecting: responseBody, upTo: limit)
        
        return try allStationsDecoder.decode(AllStations.self, from: fullData)
    }
    
    func getScheduleBetweenStations(
        from: String,
        to: String,
        date: String? = nil,
        offset: Int? = nil,
        limit: Int? = nil,
        transfers: Bool? = nil,
        resultTimeZone: String? = ScheduleDateFormatting.resultTimeZoneIdentifier
    ) async throws -> ScheduleBetweenStations {
        let response = try await client.getScheduleBetweenStations(query: .init(
            apikey: apikey,
            from: from,
            to: to,
            date: date,
            offset: offset,
            limit: limit,
            result_timezone: resultTimeZone,
            transfers: transfers
        ))
        
        if case .undocumented(404, _) = response {
            return Components.Schemas.Segments(segments: [])
        }
        
        return try response.ok.body.json
    }
    
    func getCarrierInfo(code: String) async throws -> CarrierInfo {
        let response = try await client.getCarrierInfo(query: .init(
            apikey: apikey,
            code: code
        ))
        
        return try response.ok.body.json
    }
    
    func getCopyright() async throws -> Copyright {
        let response = try await client.getCopyright(query: .init(apikey: apikey))
        return try response.ok.body.json
    }
    
    func getNearestCity(lat: Double, lng: Double, distance: Int? = nil) async throws -> NearestCity {
        let response = try await client.getNearestCity(query: .init(
            apikey: apikey,
            lat: lat,
            lng: lng,
            distance: distance
        ))
        
        return try response.ok.body.json
    }
    
    func getNearestStations(lat: Double, lng: Double, distance: Int) async throws -> NearestStations {
        let response = try await client.getNearestStations(query: .init(
            apikey: apikey,
            lat: lat,
            lng: lng,
            distance: distance
        ))
        
        return try response.ok.body.json
    }
    
    func getRouteStations(uid: String, date: String? = nil) async throws -> RouteStations {
        let response = try await client.getRouteStations(query: .init(
            apikey: apikey,
            uid: uid,
            date: date
        ))
        
        return try response.ok.body.json
    }
    
    func getStationSchedule(station: String, date: String? = nil) async throws -> StationSchedule {
        let response = try await client.getStationSchedule(query: .init(
            apikey: apikey,
            station: station,
            date: date
        ))
        
        return try response.ok.body.json
    }
}
