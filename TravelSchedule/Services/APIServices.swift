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
    
    let client: Client
    let allStations: AllStationsService
    let scheduleBetweenStations: ScheduleBetweenStationsService
    let carrierInfo: CarrierInfoService
    
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
        client = Client(
            serverURL: try Servers.Server1.url(),
            transport: URLSessionTransport()
        )
        
        allStations = AllStationsService(client: client, apikey: Constants.apiKey)
        scheduleBetweenStations = ScheduleBetweenStationsService(client: client, apikey: Constants.apiKey)
        carrierInfo = CarrierInfoService(client: client, apikey: Constants.apiKey)
    }
}
