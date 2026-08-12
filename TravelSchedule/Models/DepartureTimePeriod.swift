//
//  DepartureTimePeriod.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 09.08.2026.
//

import Foundation

enum DepartureTimePeriod: String, CaseIterable, Identifiable, Hashable {
    case morning
    case afternoon
    case evening
    case night
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .morning:
            "Утро"
        case .afternoon:
            "День"
        case .evening:
            "Вечер"
        case .night:
            "Ночь"
        }
    }
    
    var timeRange: String {
        switch self {
        case .morning:
            "06:00 - 12:00"
        case .afternoon:
            "12:00 - 18:00"
        case .evening:
            "18:00 - 00:00"
        case .night:
            "00:00 - 06:00"
        }
    }
    
    func contains(departure: Date, calendar: Calendar = ScheduleDateFormatting.calendar) -> Bool {
        contains(departureTime: ScheduleDateFormatting.formatTime(departure))
    }
    
    func contains(departureTime: String) -> Bool {
        Self.isDepartureTime(
            departureTime,
            greaterThanOrEqualTo: startTime,
            lessThan: endTimeExclusive
        )
    }
    
    static func minutesFromDepartureTime(_ departureTime: String) -> Int? {
        let trimmed = departureTime.trimmingCharacters(in: .whitespacesAndNewlines)
        let parts = trimmed.split(separator: ":")
        guard parts.count >= 2,
              let hour = Int(parts[0]),
              let minute = Int(String(parts[1].prefix(2))),
              (0..<24).contains(hour),
              (0..<60).contains(minute) else { return nil }
        return hour * 60 + minute
    }
    
    static func isDepartureTime(
        _ departureTime: String,
        greaterThanOrEqualTo start: String,
        lessThan end: String
    ) -> Bool {
        guard let value = minutesFromDepartureTime(departureTime),
              let startMinutes = minutesFromDepartureTime(start) else { return false }
        
        let endMinutes: Int
        if end == "00:00" {
            endMinutes = 24 * 60
        } else if let parsedEnd = minutesFromDepartureTime(end) {
            endMinutes = parsedEnd
        } else {
            return false
        }
        
        return value >= startMinutes && value < endMinutes
    }
    
    private var startTime: String {
        switch self {
        case .morning:
            "06:00"
        case .afternoon:
            "12:00"
        case .evening:
            "18:00"
        case .night:
            "00:00"
        }
    }
    
    private var endTimeExclusive: String {
        switch self {
        case .morning:
            "12:00"
        case .afternoon:
            "18:00"
        case .evening:
            "00:00"
        case .night:
            "06:00"
        }
    }
}
