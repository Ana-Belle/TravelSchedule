//
//  RouteStationsService.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 13.07.2026.
//

import OpenAPIRuntime
import OpenAPIURLSession

typealias RouteStations = Components.Schemas.ThreadStationsResponse

protocol RouteStationsServiceProtocol {
    func getRouteStations(uid: String, date: String?) async throws -> RouteStations
}

final class RouteStationsService: BaseService, RouteStationsServiceProtocol {

    func getRouteStations(uid: String, date: String? = nil) async throws -> RouteStations {

        let response = try await client.getRouteStations(query: .init(
            apikey: apikey,
            uid: uid,
            date: date
        ))

        return try response.ok.body.json
    }
}
