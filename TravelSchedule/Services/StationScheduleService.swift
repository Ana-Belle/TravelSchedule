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
        try await networkClient.getStationSchedule(station: station, date: date)
    }
}
