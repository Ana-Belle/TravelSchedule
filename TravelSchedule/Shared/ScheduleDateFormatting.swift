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
        
        let localFormatters: [DateFormatter] = [
            localDateFormatter(format: "yyyy-MM-dd'T'HH:mm:ssXXXXX"),
            localDateFormatter(format: "yyyy-MM-dd'T'HH:mm:ssZ"),
            localDateFormatter(format: "yyyy-MM-dd'T'HH:mm:ss"),
            localDateFormatter(format: "yyyy-MM-dd HH:mm:ss")
        ]
        
        for formatter in localFormatters {
            if let date = formatter.date(from: string) {
                return date
            }
        }
        
        return nil
    }
    
    /// Wall-clock `HH:mm` from an API date-time string (preferred over reformatting `Date`,
    /// so filters match the time shown in the list).
    static func timeString(from dateTimeString: String) -> String? {
        if let time = wallClockTime(from: dateTimeString) {
            return time
        }
        
        guard let date = parse(dateTimeString) else { return nil }
        return formatTime(date)
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
    
    private static func wallClockTime(from dateTimeString: String) -> String? {
        guard let timeSeparator = dateTimeString.firstIndex(of: "T")
                ?? dateTimeString.firstIndex(of: " ") else {
            return nil
        }
        
        let timePart = dateTimeString[dateTimeString.index(after: timeSeparator)...]
        let parts = timePart.split(separator: ":")
        guard parts.count >= 2,
              let hour = Int(parts[0]),
              let minute = Int(String(parts[1]).prefix(2)),
              (0..<24).contains(hour),
              (0..<60).contains(minute) else {
            return nil
        }
        
        return String(format: "%02d:%02d", hour, minute)
    }
    
    private static func iso8601Formatter(_ options: ISO8601DateFormatter.Options) -> ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = options
        formatter.timeZone = timeZone
        return formatter
    }
    
    private static func localDateFormatter(format: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.timeZone = timeZone
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = format
        return formatter
    }
}
