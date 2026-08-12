//
//  ScheduleBetweenStationsService.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 12.07.2026.
//

import OpenAPIRuntime
import OpenAPIURLSession

typealias ScheduleBetweenStations = Components.Schemas.Segments

protocol ScheduleBetweenStationsServiceProtocol {
    func getScheduleBetweenStations(
        from: String,
        to: String,
        date: String?,
        offset: Int?,
        limit: Int?,
        transfers: Bool?,
        resultTimeZone: String?
    ) async throws -> ScheduleBetweenStations
}

final class ScheduleBetweenStationsService: BaseService, ScheduleBetweenStationsServiceProtocol {

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
        
        return try response.ok.body.json
    }
}
