//
//  Story.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 18.08.2026.
//

import Foundation

struct Story: Identifiable, Sendable {
    let id: Int
    let imageName: String
    let title: String
    let description: String
}

extension Story {
    static let mocks: [Story] = (1...5).map { index in
        Story(
            id: index - 1,
            imageName: "Story\(index)",
            title: "Text Text Text Text Text Text Text Text Text",
            description: "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text"
        )
    }
}

