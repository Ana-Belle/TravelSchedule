//
//  ScheduleResultViewModel.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 06.08.2026.
//

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

@MainActor
@Observable
final class ScheduleResultViewModel {
    let fromStation: Station
    let toStation: Station

    var scheduleItems: [ScheduleItem] = []
    var isLoading = false
    var errorState: AppErrorState?

    var routeTitle: String {
        "\(fromStation.title) → \(toStation.title)"
    }

    init(fromStation: Station, toStation: Station) {
        self.fromStation = fromStation
        self.toStation = toStation
    }

    func loadSchedule() async {
        isLoading = true
        errorState = nil

        defer { isLoading = false }

        do {
            let client = Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            )
            let service = ScheduleBetweenStationsService(client: client, apikey: Constants.apiKey)
            let segments = try await fetchAllSegments(service: service)
            scheduleItems = Self.extractScheduleItems(from: segments)
        } catch {
            errorState = AppErrorState(error: error)
        }
    }

    private func fetchAllSegments(service: ScheduleBetweenStationsServiceProtocol) async throws -> [Components.Schemas.Segment] {
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: Date())
        var allSegments: [Components.Schemas.Segment] = []
        var dayOffset = 0
        let batchSize = 7
        let maxDays = 90

        while dayOffset < maxDays {
            let batchEnd = min(dayOffset + batchSize, maxDays)
            let batchSegments = try await fetchSegmentsBatch(
                service: service,
                calendar: calendar,
                startDate: startDate,
                dayRange: dayOffset..<batchEnd
            )

            if batchSegments.isEmpty {
                break
            }

            allSegments.append(contentsOf: batchSegments)
            dayOffset = batchEnd
        }

        return allSegments
    }

    private func fetchSegmentsBatch(
        service: ScheduleBetweenStationsServiceProtocol,
        calendar: Calendar,
        startDate: Date,
        dayRange: Range<Int>
    ) async throws -> [Components.Schemas.Segment] {
        try await withThrowingTaskGroup(of: [Components.Schemas.Segment].self) { group in
            for dayOffset in dayRange {
                guard let date = calendar.date(byAdding: .day, value: dayOffset, to: startDate) else {
                    continue
                }

                let dateString = Self.dateString(from: date)

                group.addTask {
                    try await self.fetchSegments(for: dateString, service: service)
                }
            }

            var batchSegments: [Components.Schemas.Segment] = []
            for try await daySegments in group {
                batchSegments.append(contentsOf: daySegments)
            }
            return batchSegments
        }
    }

    private func fetchSegments(
        for date: String,
        service: ScheduleBetweenStationsServiceProtocol
    ) async throws -> [Components.Schemas.Segment] {
        var allSegments: [Components.Schemas.Segment] = []
        var offset = 0
        let pageSize = 100

        while true {
            let response = try await service.getScheduleBetweenStations(
                from: fromStation.id,
                to: toStation.id,
                date: date,
                offset: offset,
                limit: pageSize
            )

            let segments = response.segments ?? []
            allSegments.append(contentsOf: segments)

            let total = response.pagination?.total ?? segments.count
            offset += segments.count

            if segments.isEmpty || offset >= total {
                break
            }
        }

        return allSegments
    }

    private static func dateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    private static var startOfToday: Date {
        Calendar.current.startOfDay(for: Date())
    }

    private static func extractScheduleItems(from segments: [Components.Schemas.Segment]) -> [ScheduleItem] {
        segments
            .filter { ($0.departure ?? .distantPast) >= startOfToday }
            .sorted { ($0.departure ?? .distantPast) < ($1.departure ?? .distantPast) }
            .compactMap(makeScheduleItem(from:))
    }

    private static func makeScheduleItem(from segment: Components.Schemas.Segment) -> ScheduleItem? {
        guard
            let departureDateValue = segment.departure,
            let arrivalDateValue = segment.arrival,
            let carrierTitle = segment.thread?.carrier?.title
        else { return nil }

        let durationSeconds = segment.duration ?? Int(arrivalDateValue.timeIntervalSince(departureDateValue))
        let id = "\(segment.thread?.uid ?? carrierTitle)-\(departureDateValue.timeIntervalSince1970)"

        return ScheduleItem(
            id: id,
            carrierTitle: carrierTitle,
            logoURL: segment.thread?.carrier?.logo,
            departureDate: formatDate(departureDateValue),
            departureTime: formatTime(departureDateValue),
            arrivalTime: formatTime(arrivalDateValue),
            durationText: formatDuration(seconds: durationSeconds)
        )
    }

    private static func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMMM"
        return formatter.string(from: date)
    }

    private static func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }

    private static func formatDuration(seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60

        switch (hours, minutes) {
        case (0, let minutes):
            return "\(minutes) \(pluralForm(minutes, one: "минута", few: "минуты", many: "минут"))"
        case (let hours, 0):
            return "\(hours) \(pluralForm(hours, one: "час", few: "часа", many: "часов"))"
        default:
            return "\(hours) \(pluralForm(hours, one: "час", few: "часа", many: "часов")) \(minutes) \(pluralForm(minutes, one: "минута", few: "минуты", many: "минут"))"
        }
    }

    private static func pluralForm(_ count: Int, one: String, few: String, many: String) -> String {
        let remainder = abs(count) % 100
        let lastDigit = abs(count) % 10

        if remainder >= 11 && remainder <= 14 {
            return many
        }

        switch lastDigit {
        case 1:
            return one
        case 2, 3, 4:
            return few
        default:
            return many
        }
    }
}
