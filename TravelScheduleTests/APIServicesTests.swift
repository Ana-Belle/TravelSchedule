//
//  APIServicesTests.swift
//  TravelScheduleTests
//
//  Created by Anastasia Belyakova on 10.09.2026.
//

import XCTest
@testable import TravelSchedule

final class APIServicesTests: XCTestCase {
    
    override func setUp() async throws {
        try await super.setUp()
        try XCTSkipIf(
            !APIServices.bootstrap(),
            "Не удалось инициализировать APIServices. Проверьте API_KEY в Config.xcconfig."
        )
    }
    
    func testNearestStations() async throws {
        let stations = try await APIServices.shared.nearestStations.getNearestStations(
            lat: 59.864177,
            lng: 30.319163,
            distance: 50
        )
        
        XCTAssertNotNil(stations)
    }
    
    func testScheduleBetweenStations() async throws {
        let schedule = try await APIServices.shared.scheduleBetweenStations.getScheduleBetweenStations(
            from: "c146",
            to: "c213",
            date: "2026-08-01"
        )
        
        XCTAssertNotNil(schedule)
    }
    
    func testStationSchedule() async throws {
        let schedule = try await APIServices.shared.stationSchedule.getStationSchedule(
            station: "s9600213",
            date: "2026-08-01"
        )
        
        XCTAssertNotNil(schedule)
    }
    
    func testRouteStations() async throws {
        let stations = try await APIServices.shared.routeStations.getRouteStations(
            uid: "038AA_tis",
            date: "2026-08-01"
        )
        
        XCTAssertNotNil(stations)
    }
    
    func testNearestCity() async throws {
        let city = try await APIServices.shared.nearestCity.getNearestCity(
            lat: 50.440046,
            lng: 40.4882367,
            distance: 50
        )
        
        XCTAssertNotNil(city)
    }
    
    func testCarrierInfo() async throws {
        let info = try await APIServices.shared.carrierInfo.getCarrierInfo(
            code: "TK"
        )
        
        XCTAssertNotNil(info)
    }
    
    func testAllStations() async throws {
        let stations = try await APIServices.shared.allStations.getAllStations()
        
        XCTAssertNotNil(stations)
    }
    
    func testCopyright() async throws {
        let copyright = try await APIServices.shared.copyright.getCopyright()
        
        XCTAssertNotNil(copyright)
    }
}
