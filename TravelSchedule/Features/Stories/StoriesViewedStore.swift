//
//  StoriesViewedStore.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 18.08.2026.
//

import Foundation

@Observable
final class StoriesViewedStore {
    private static let storageKey = "viewedStoryIDs"
    
    private(set) var viewedStoryIDs: Set<Int> = []
    
    init() {
        let storedIDs = UserDefaults.standard.array(forKey: Self.storageKey) as? [Int] ?? []
        viewedStoryIDs = Set(storedIDs)
    }
    
    func isViewed(_ storyID: Int) -> Bool {
        viewedStoryIDs.contains(storyID)
    }
    
    func markAsViewed(_ storyID: Int) {
        guard !viewedStoryIDs.contains(storyID) else { return }
        viewedStoryIDs.insert(storyID)
        UserDefaults.standard.set(Array(viewedStoryIDs), forKey: Self.storageKey)
    }
}
