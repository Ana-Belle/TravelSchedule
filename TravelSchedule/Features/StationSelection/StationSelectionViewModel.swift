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
    var searchText = ""
    
    var filteredStations: [Station] {
        filteredStations(searchText: searchText)
    }
    
    var isSearchActive: Bool {
        !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
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
