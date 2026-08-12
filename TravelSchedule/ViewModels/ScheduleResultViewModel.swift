//
//  ScheduleResultViewModel.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 06.08.2026.
//

import Foundation
import OpenAPIRuntime

@MainActor
@Observable
final class ScheduleResultViewModel {
    let fromStation: Station
    let toStation: Station
    
    var scheduleItems: [ScheduleItem] = []
    var isLoading = false
    var isLoadingMore = false
    var hasMoreDays = true
    var hasCompletedInitialLoad = false
    var errorState: AppErrorState?
    var filters = ScheduleFilters()
    
    private var cacheWithTransfers = ScheduleCache()
    private var cacheDirect = ScheduleCache()
    
    private let initialDayCount = 3
    private let loadMoreDayCount = 3
    private let maxDays = 90
    
    private let scheduleService: ScheduleBetweenStationsServiceProtocol
    
    var routeTitle: String {
        "\(fromStation.title) → \(toStation.title)"
    }
    
    var hasLoadedSchedule: Bool {
        !cacheWithTransfers.items.isEmpty || !cacheDirect.items.isEmpty
    }
    
    init(
        fromStation: Station,
        toStation: Station,
        scheduleService: ScheduleBetweenStationsServiceProtocol = APIServices.shared.scheduleBetweenStations
    ) {
        self.fromStation = fromStation
        self.toStation = toStation
        self.scheduleService = scheduleService
    }
    
    private var effectiveTransfers: TransfersFilter {
        filters.transfers ?? .yes
    }
    
    func loadSchedule() async {
        isLoading = true
        errorState = nil
        cacheWithTransfers = ScheduleCache()
        cacheDirect = ScheduleCache()
        scheduleItems = []
        hasMoreDays = true
        hasCompletedInitialLoad = false
        
        defer {
            isLoading = false
            hasCompletedInitialLoad = true
            syncPaginationState()
        }
        
        do {
            try await loadInitialBatch(for: effectiveTransfers, service: scheduleService)
            applyFilters(filters)
        } catch {
            errorState = AppErrorState(error: error)
        }
    }
    
    func loadMoreIfNeeded() async {
        guard hasCompletedInitialLoad, hasMoreDays, !isLoading, !isLoadingMore else { return }
        
        isLoadingMore = true
        defer {
            isLoadingMore = false
            syncPaginationState()
        }
        
        do {
            try await loadNextDays(count: loadMoreDayCount, for: effectiveTransfers, service: scheduleService)
            applyFilters(filters)
        } catch {
            errorState = AppErrorState(error: error)
        }
    }
    
    func applyFilters(_ appliedFilters: ScheduleFilters) {
        filters = appliedFilters
        
        if activeCache.hasInitialLoad {
            scheduleItems = filterItems(activeItems)
            return
        }
        
        Task {
            await ensureActiveCacheLoaded()
            scheduleItems = filterItems(activeItems)
        }
    }
    
    private func ensureActiveCacheLoaded() async {
        guard !activeCache.hasInitialLoad else { return }
        
        let useSoftLoading = hasCompletedInitialLoad && hasLoadedSchedule
        
        if useSoftLoading {
            isLoadingMore = true
        } else {
            isLoading = true
        }
        
        defer {
            isLoading = false
            isLoadingMore = false
            syncPaginationState()
        }
        
        do {
            try await loadInitialBatch(for: effectiveTransfers, service: scheduleService)
        } catch {
            errorState = AppErrorState(error: error)
        }
    }
    
    private var activeItems: [ScheduleItem] {
        switch effectiveTransfers {
        case .yes:
            cacheWithTransfers.items
        case .no:
            cacheDirect.items
        }
    }
    
    private var activeCache: ScheduleCache {
        switch effectiveTransfers {
        case .yes:
            cacheWithTransfers
        case .no:
            cacheDirect
        }
    }
    
    private func syncPaginationState() {
        hasMoreDays = activeCache.hasMoreDays
    }
    
    private func loadInitialBatch(
        for transfers: TransfersFilter,
        service: ScheduleBetweenStationsServiceProtocol
    ) async throws {
        try await loadNextDays(count: initialDayCount, for: transfers, service: service)
        
        var currentCache = scheduleCache(for: transfers)
        while currentCache.items.isEmpty && currentCache.hasMoreDays {
            try await loadNextDays(count: loadMoreDayCount, for: transfers, service: service)
            currentCache = scheduleCache(for: transfers)
        }
        
        setScheduleCache(scheduleCache(for: transfers).withInitialLoadCompleted(), for: transfers)
    }
    
    private func loadNextDays(
        count: Int,
        for transfers: TransfersFilter,
        service: ScheduleBetweenStationsServiceProtocol
    ) async throws {
        var currentCache = scheduleCache(for: transfers)
        
        guard currentCache.nextDayOffset < maxDays else {
            currentCache.hasMoreDays = false
            setScheduleCache(currentCache, for: transfers)
            return
        }
        
        let calendar = ScheduleDateFormatting.calendar
        let startDate = calendar.startOfDay(for: Date())
        let batchEnd = min(currentCache.nextDayOffset + count, maxDays)
        
        let batchSegments = try await fetchSegmentsBatch(
            service: service,
            calendar: calendar,
            startDate: startDate,
            dayRange: currentCache.nextDayOffset..<batchEnd,
            includeTransfers: transfers == .yes
        )
        
        let newItems = Self.extractScheduleItems(from: batchSegments)
        currentCache.items.append(contentsOf: newItems)
        currentCache.items.sort { $0.departure < $1.departure }
        
        currentCache.nextDayOffset = batchEnd
        currentCache.hasMoreDays = currentCache.nextDayOffset < maxDays
        setScheduleCache(currentCache, for: transfers)
    }
    
    private func scheduleCache(for transfers: TransfersFilter) -> ScheduleCache {
        switch transfers {
        case .yes:
            cacheWithTransfers
        case .no:
            cacheDirect
        }
    }
    
    private func setScheduleCache(_ cache: ScheduleCache, for transfers: TransfersFilter) {
        switch transfers {
        case .yes:
            cacheWithTransfers = cache
        case .no:
            cacheDirect = cache
        }
    }
    
    private func filterItems(_ items: [ScheduleItem]) -> [ScheduleItem] {
        guard !filters.selectedPeriods.isEmpty else { return items }
        
        return items.filter { item in
            filters.selectedPeriods.contains { period in
                period.contains(departureTime: item.departureTime)
            }
        }
    }
    
    private func fetchSegmentsBatch(
        service: ScheduleBetweenStationsServiceProtocol,
        calendar: Calendar,
        startDate: Date,
        dayRange: Range<Int>,
        includeTransfers: Bool
    ) async throws -> [Components.Schemas.Segment] {
        var batchSegments: [Components.Schemas.Segment] = []
        
        for dayOffset in dayRange {
            guard let date = calendar.date(byAdding: .day, value: dayOffset, to: startDate) else {
                continue
            }
            
            let dateString = Self.dateString(from: date)
            let daySegments = try await fetchSegments(
                for: dateString,
                service: service,
                includeTransfers: includeTransfers
            )
            batchSegments.append(contentsOf: daySegments)
        }
        
        return batchSegments
    }
    
    private func fetchSegments(
        for date: String,
        service: ScheduleBetweenStationsServiceProtocol,
        includeTransfers: Bool
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
                limit: pageSize,
                transfers: includeTransfers,
                resultTimeZone: ScheduleDateFormatting.resultTimeZoneIdentifier
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
        formatter.calendar = ScheduleDateFormatting.calendar
        formatter.timeZone = ScheduleDateFormatting.timeZone
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    private static var startOfToday: Date {
        ScheduleDateFormatting.calendar.startOfDay(for: Date())
    }
    
    private static func extractScheduleItems(from segments: [Components.Schemas.Segment]) -> [ScheduleItem] {
        segments
            .compactMap(makeScheduleItem(from:))
            .filter { $0.departure >= startOfToday }
            .sorted { $0.departure < $1.departure }
    }
    
    private static func makeScheduleItem(from segment: Components.Schemas.Segment) -> ScheduleItem? {
        guard
            let departureDateValue = segment.departure,
            let arrivalDateValue = segment.arrival,
            let carrierTitle = carrierTitle(from: segment)
        else { return nil }
        
        let durationSeconds = Int(segment.duration ?? arrivalDateValue.timeIntervalSince(departureDateValue))
        let threadUID = segment.thread?.uid ?? segment.details?.compactMap(\.thread?.uid).first
        let id = "\(threadUID ?? carrierTitle)-\(departureDateValue.timeIntervalSince1970)"
        
        return ScheduleItem(
            id: id,
            carrierTitle: carrierTitle,
            logoURL: carrierLogo(from: segment),
            transferCity: transferCity(from: segment),
            departure: departureDateValue,
            departureDate: ScheduleDateFormatting.formatDate(departureDateValue),
            departureTime: ScheduleDateFormatting.formatTime(departureDateValue),
            arrivalTime: ScheduleDateFormatting.formatTime(arrivalDateValue),
            durationText: formatDuration(seconds: durationSeconds)
        )
    }
    
    private static func carrierTitle(from segment: Components.Schemas.Segment) -> String? {
        if let title = segment.thread?.carrier?.title {
            return title
        }
        
        return segment.details?.compactMap(\.thread?.carrier?.title).first
    }
    
    private static func carrierLogo(from segment: Components.Schemas.Segment) -> String? {
        if let logo = segment.thread?.carrier?.logo {
            return logo
        }
        
        return segment.details?.compactMap(\.thread?.carrier?.logo).first
    }
    
    private static func transferCity(from segment: Components.Schemas.Segment) -> String? {
        guard segment.has_transfers == true else { return nil }
        
        guard let transfer = segment.transfers?.first else { return nil }
        
        return transfer.title ?? transfer.popular_title ?? transfer.short_title
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

private struct ScheduleCache {
    var items: [ScheduleItem] = []
    var nextDayOffset = 0
    var hasMoreDays = true
    var hasInitialLoad = false
    
    func withInitialLoadCompleted() -> ScheduleCache {
        var cache = self
        cache.hasInitialLoad = true
        return cache
    }
}
