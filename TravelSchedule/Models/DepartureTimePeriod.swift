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
        let hour = calendar.component(.hour, from: departure)
        let minute = calendar.component(.minute, from: departure)
        return contains(minutesFromMidnight: hour * 60 + minute)
    }

    func contains(departureTime: String) -> Bool {
        guard let minutesFromMidnight = Self.minutesFromDepartureTime(departureTime) else {
            return false
        }
        return contains(minutesFromMidnight: minutesFromMidnight)
    }

    static func minutesFromDepartureTime(_ departureTime: String) -> Int? {
        let parts = departureTime.split(separator: ":")
        guard parts.count >= 2,
              let hour = Int(parts[0]),
              let minute = Int(String(parts[1].prefix(2))),
              (0..<24).contains(hour),
              (0..<60).contains(minute) else { return nil }
        return hour * 60 + minute
    }

    private static func minutes(from departureTime: String) -> Int? {
        minutesFromDepartureTime(departureTime)
    }

    private func contains(minutesFromMidnight: Int) -> Bool {
        switch self {
        case .morning:
            return minutesFromMidnight >= 6 * 60 && minutesFromMidnight < 12 * 60
        case .afternoon:
            return minutesFromMidnight >= 12 * 60 && minutesFromMidnight < 18 * 60
        case .evening:
            return minutesFromMidnight >= 18 * 60 && minutesFromMidnight < 24 * 60
        case .night:
            return minutesFromMidnight >= 0 && minutesFromMidnight < 6 * 60
        }
    }
}
