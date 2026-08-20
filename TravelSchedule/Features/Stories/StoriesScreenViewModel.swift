//
//  StoriesScreenViewModel.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 20.08.2026.
//

import Foundation

@MainActor
@Observable
final class StoriesScreenViewModel {
    enum DragEndResult: Sendable {
        case dismissScreen
        case resetOffset
    }
    
    let stories: [Story]
    var currentIndex: Int
    var progress = 0.0
    var verticalDragOffset: CGFloat = 0
    var shouldDismiss = false
    
    private let storyDuration: TimeInterval = 10
    private let dismissDragThreshold: CGFloat = 120
    private let viewedStore: StoriesViewedStore
    
    var currentStory: Story {
        stories[currentIndex]
    }
    
    var dismissOpacity: Double {
        let dragProgress = min(max(verticalDragOffset / 300, 0), 1)
        return 1 - dragProgress * 0.4
    }
    
    init(
        stories: [Story] = StoriesContent.stories,
        initialIndex: Int = 0,
        viewedStore: StoriesViewedStore
    ) {
        self.stories = stories
        self.currentIndex = initialIndex
        self.viewedStore = viewedStore
    }
    
    func progressWidth(for index: Int, totalWidth: CGFloat) -> CGFloat {
        if index < currentIndex {
            return totalWidth
        }
        
        if index > currentIndex {
            return 0
        }
        
        return totalWidth * progress
    }
    
    func markCurrentStoryAsViewed() {
        viewedStore.markAsViewed(stories[currentIndex].id)
    }
    
    func requestDismiss() {
        shouldDismiss = true
    }
    
    func goToNextStory() {
        if currentIndex < stories.count - 1 {
            currentIndex += 1
        } else {
            shouldDismiss = true
        }
    }
    
    func goToPreviousStory() {
        guard currentIndex > 0 else { return }
        currentIndex -= 1
    }
    
    func handleDragChanged(translation: CGSize) {
        guard abs(translation.height) > abs(translation.width) else { return }
        verticalDragOffset = max(0, translation.height)
    }
    
    func handleDragEnded(translation: CGSize) -> DragEndResult {
        let horizontalMovement = translation.width
        let verticalMovement = translation.height
        
        if verticalMovement > dismissDragThreshold,
           abs(verticalMovement) > abs(horizontalMovement) {
            return .dismissScreen
        }
        
        if horizontalMovement < -50 {
            goToNextStory()
        } else if horizontalMovement > 50 {
            goToPreviousStory()
        }
        
        return .resetOffset
    }
    
    func resetDragOffset() {
        verticalDragOffset = 0
    }
    
    func runStoryTimer() async {
        progress = 0
        let startDate = Date()
        
        while !Task.isCancelled {
            let elapsed = Date().timeIntervalSince(startDate)
            progress = min(elapsed / storyDuration, 1)
            
            if elapsed >= storyDuration {
                goToNextStory()
                return
            }
            
            try? await Task.sleep(for: .milliseconds(50))
        }
    }
}
