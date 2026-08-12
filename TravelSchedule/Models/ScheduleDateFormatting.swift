//
//  ScheduleDateFormatting.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 12.08.2026.
//

import Foundation

enum ScheduleDateFormatting {
    static let timeZone = TimeZone.current
    
    static var calendar: Calendar {
        var calendar = Calendar.current
        calendar.timeZone = timeZone
        return calendar
    }
    
    static var resultTimeZoneIdentifier: String {
        timeZone.identifier
    }
    
    static func parse(_ string: String) -> Date? {
        let formatters = [
            iso8601Formatter([.withInternetDateTime, .withFractionalSeconds]),
            iso8601Formatter([.withInternetDateTime])
        ]
        
        for formatter in formatters {
            if let date = formatter.date(from: string) {
                return date
            }
        }
        
        return nil
    }
    
    static func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.timeZone = timeZone
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMMM"
        return formatter.string(from: date)
    }
    
    static func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.timeZone = timeZone
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    private static func iso8601Formatter(_ options: ISO8601DateFormatter.Options) -> ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = options
        return formatter
    }
}
