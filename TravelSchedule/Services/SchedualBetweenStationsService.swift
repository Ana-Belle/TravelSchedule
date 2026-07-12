//
//  SchedualBetweenStationsService.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 12.07.2026.
//

import OpenAPIRuntime
import OpenAPIURLSession

typealias SchedualBetweenStations = Components.Schemas.Segments

protocol SchedualBetweenStationsServiceProtocol {
    func getSchedualBetweenStations(from: String, to: String, date: String?) async throws -> SchedualBetweenStations
}

final class SchedualBetweenStationsService: BaseService, SchedualBetweenStationsServiceProtocol {

    func getSchedualBetweenStations(from: String, to: String, date: String? = nil) async throws -> SchedualBetweenStations {

        let response = try await client.getSchedualBetweenStations(query: .init(
            apikey: apikey,
            from: from,
            to: to,
            date: date
        ))

        return try response.ok.body.json
    }
}
