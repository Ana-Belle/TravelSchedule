//
//  APIServices.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 10.08.2026.
//

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

final class APIServices {
    private(set) static var shared: APIServices!
    
    let networkClient: NetworkClient
    let allStations: AllStationsService
    let scheduleBetweenStations: ScheduleBetweenStationsService
    let carrierInfo: CarrierInfoService
    let copyright: CopyrightService
    let nearestCity: NearestCityService
    let nearestStations: NearestStationsService
    let routeStations: RouteStationsService
    let stationSchedule: StationScheduleService
    
    @discardableResult
    static func bootstrap() -> Bool {
        guard shared == nil else { return true }
        
        do {
            shared = try APIServices()
            return true
        } catch {
            shared = nil
            return false
        }
    }
    
    private init() throws {
        let client = Client(
            serverURL: try Servers.Server1.url(),
            transport: URLSessionTransport()
        )
        
        networkClient = NetworkClient(client: client, apikey: Constants.apiKey)
        
        allStations = AllStationsService(networkClient: networkClient)
        scheduleBetweenStations = ScheduleBetweenStationsService(networkClient: networkClient)
        carrierInfo = CarrierInfoService(networkClient: networkClient)
        copyright = CopyrightService(networkClient: networkClient)
        nearestCity = NearestCityService(networkClient: networkClient)
        nearestStations = NearestStationsService(networkClient: networkClient)
        routeStations = RouteStationsService(networkClient: networkClient)
        stationSchedule = StationScheduleService(networkClient: networkClient)
    }
}
