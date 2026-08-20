//
//  ScheduleFilters.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 09.08.2026.
//

import Foundation

enum TransfersFilter: Hashable, Sendable {
    case withTransfers
    case withoutTransfers
}

struct ScheduleFilters: Hashable, Sendable {
    var selectedPeriods: Set<DepartureTimePeriod> = []
    var transfers: TransfersFilter? = nil
    
    var hasActiveFilters: Bool {
        !selectedPeriods.isEmpty || transfers != nil
    }
}
