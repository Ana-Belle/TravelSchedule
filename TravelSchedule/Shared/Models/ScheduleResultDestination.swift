//
//  ScheduleResultDestination.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 12.08.2026.
//

import Foundation

enum ScheduleResultDestination: Hashable {
    case filter
    case carrierInfo(carrierCode: String)
}
