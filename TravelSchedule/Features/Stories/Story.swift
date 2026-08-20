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

enum StoriesContent {
    static let stories: [Story] = [
        Story(id: 0, imageName: "Story1", title: "Text Text Text Text Text Text Text Text Text", description: "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text"),
        Story(id: 1, imageName: "Story2", title: "Text Text Text Text Text Text Text Text Text", description: "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text"),
        Story(id: 2, imageName: "Story3", title: "Text Text Text Text Text Text Text Text Text", description: "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text"),
        Story(id: 3, imageName: "Story4", title: "Text Text Text Text Text Text Text Text Text", description: "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text"),
        Story(id: 4, imageName: "Story5", title: "Text Text Text Text Text Text Text Text Text", description: "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text")
    ]
}
