//
//  StationSelectionViewModel.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 05.08.2026.
//

import Foundation

@MainActor
@Observable
final class StationSelectionViewModel {
    let city: City

    init(city: City) {
        self.city = city
    }

    func filteredStations(searchText: String) -> [Station] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return city.stations }

        return city.stations.filter {
            $0.title.localizedCaseInsensitiveContains(query)
        }
    }
}
