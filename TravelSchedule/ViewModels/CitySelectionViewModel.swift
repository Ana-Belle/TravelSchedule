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
    var errorMessage: String?

    func filteredCities(searchText: String) -> [City] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return cities }

        return cities.filter {
            $0.title.localizedCaseInsensitiveContains(query)
        }
    }

    func loadCities() async {
        isLoading = true
        errorMessage = nil

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
            errorMessage = error.localizedDescription
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
                    cities.append(City(id: code, title: title))
                }
            }
        }

        return cities.sorted {
            $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending
        }
    }
}
