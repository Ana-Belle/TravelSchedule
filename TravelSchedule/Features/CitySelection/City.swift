//
//  City.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 05.08.2026.
//

import Foundation

struct City: Identifiable, Hashable, Sendable {
    let id: String
    let title: String
    let stations: [Station]
}
