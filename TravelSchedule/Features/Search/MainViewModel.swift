//
//  MainViewModel.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 20.08.2026.
//

import SwiftUI

@MainActor
@Observable
final class MainViewModel {
    var fromStation: Station?
    var toStation: Station?
    var presentedStory: PresentedStory?
    
    let stories: [Story]
    let storiesViewedStore: StoriesViewedStore
    
    init(
        stories: [Story] = StoriesContent.stories,
        storiesViewedStore: StoriesViewedStore = StoriesViewedStore()
    ) {
        self.stories = stories
        self.storiesViewedStore = storiesViewedStore
    }
    
    var canSearch: Bool {
        fromStation != nil && toStation != nil
    }
    
    func swapStations() {
        swap(&fromStation, &toStation)
    }
    
    func stationTitle(for field: StationField) -> String {
        switch field {
        case .from:
            fromStation?.title ?? field.placeholder
        case .to:
            toStation?.title ?? field.placeholder
        }
    }
    
    func stationTitleColor(for field: StationField) -> Color {
        let isSelected = switch field {
        case .from:
            fromStation != nil
        case .to:
            toStation != nil
        }
        
        return isSelected ? .blackUniversal : .grayUniversal
    }
    
    func isStoryViewed(_ storyID: Int) -> Bool {
        storiesViewedStore.isViewed(storyID)
    }
    
    func openStory(id: Int) {
        presentedStory = PresentedStory(id: id)
    }
    
    func makeSearchRoute() -> ScheduleSearchRoute? {
        guard let fromStation, let toStation else { return nil }
        
        return ScheduleSearchRoute(fromStation: fromStation, toStation: toStation)
    }
}

struct PresentedStory: Identifiable, Sendable {
    let id: Int
}
