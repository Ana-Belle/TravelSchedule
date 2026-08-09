//
//  ScheduleItem.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 07.08.2026.
//

import Foundation

struct ScheduleItem: Identifiable, Hashable {
    let id: String
    let carrierTitle: String
    let logoURL: String?
    let departureDate: String
    let departureTime: String
    let arrivalTime: String
    let durationText: String
}
