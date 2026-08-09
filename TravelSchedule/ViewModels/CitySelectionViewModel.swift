//
//  CitySelectionViewModel.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 05.08.2026.
//

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

@MainActor
@Observable
final class CitySelectionViewModel {
    var cities: [City] = []
    var isLoading = false
    var errorState: AppErrorState?

    func filteredCities(searchText: String) -> [City] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return cities }

        return cities.filter {
            $0.title.localizedCaseInsensitiveContains(query)
        }
    }

    func loadCities() async {
        isLoading = true
        errorState = nil

        defer { isLoading = false }

        do {
            let client = Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            )
            let service = AllStationsService(client: client, apikey: Constants.apiKey)
            let response = try await service.getAllStations()
            cities = Self.extractCities(from: response)
        } catch {
            errorState = AppErrorState(error: error)
        }
    }

    private static func extractCities(from response: AllStations) -> [City] {
        var cities: [City] = []
        var seenCodes = Set<String>()

        for country in response.countries ?? [] {
            for region in country.regions ?? [] {
                for settlement in region.settlements ?? [] {
                    guard
                        let title = settlement.title,
                        let code = settlement.codes?.yandex_code,
                        !seenCodes.contains(code)
                    else { continue }

                    seenCodes.insert(code)
                    cities.append(
                        City(
                            id: code,
                            title: title,
                            stations: extractStations(from: settlement)
                        )
                    )
                }
            }
        }

        return cities.sorted {
            $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending
        }
    }

    private static func extractStations(from settlement: Components.Schemas.Settlement) -> [Station] {
        var stations: [Station] = []
        var seenCodes = Set<String>()

        for station in settlement.stations ?? [] {
            let code = station.codes?.yandex_code ?? station.code
            guard
                let code,
                !seenCodes.contains(code)
            else { continue }

            let title = station.title ?? station.popular_title ?? station.short_title
            guard let title else { continue }

            seenCodes.insert(code)
            stations.append(Station(id: code, title: title))
        }

        return stations.sorted {
            $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending
        }
    }
}
