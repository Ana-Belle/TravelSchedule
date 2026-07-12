//
//  StationScheduleService.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 13.07.2026.
//

import OpenAPIRuntime
import OpenAPIURLSession

typealias StationSchedule = Components.Schemas.ScheduleResponse

protocol StationScheduleServiceProtocol {
    func getStationSchedule(station: String, date: String?) async throws -> StationSchedule
}

final class StationScheduleService: BaseService, StationScheduleServiceProtocol {

    func getStationSchedule(station: String, date: String? = nil) async throws -> StationSchedule {

        let response = try await client.getStationSchedule(query: .init(
            apikey: apikey,
            station: station,
            date: date
        ))

        return try response.ok.body.json
    }
}

