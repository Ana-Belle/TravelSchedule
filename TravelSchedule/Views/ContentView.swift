//
//  ContentView.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 08.07.2026.
//

import SwiftUI
import OpenAPIRuntime
import OpenAPIURLSession

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            testServices()
        }
    }
    
    private func testServices() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                
                print("Fetching services...")
                
                testFetchStations(client: client)
                testSchedualBetweenStations(client: client)
                testStationSchedule(client: client)
                testRouteStations(client: client)
                testNearestCity(client: client)
                testCarrierInfo(client: client)
                testAllStations(client: client)
                testCopyright(client: client)
                
            } catch {
                print("Error fetching services: \(error)")
            }
        }
    }
    
    
    private func testFetchStations(client: Client) {
        Task {
            do {
                let service = NearestStationsService(
                    client: client,
                    apikey: Constants.apiKey
                )
                
                print("Fetching stations...")
                let stations = try await service.getNearestStations(
                    lat: 59.864177,
                    lng: 30.319163,
                    distance: 50
                )
                
                print("Successfully fetched stations: \(stations)")
            } catch {
                print("Error fetching stations: \(error)")
            }
        }
    }
    
    private func testSchedualBetweenStations(client: Client) {
        Task {
            do {
                let service = SchedualBetweenStationsService(
                    client: client,
                    apikey: Constants.apiKey
                )
                
                print("Fetching schedual between stations...")
                let schedual = try await service.getSchedualBetweenStations(
                    from: "c146",
                    to: "c213",
                    date: "2026-08-01"
                )
                
                print("Successfully fetched schedual between stations: \(schedual)")
            } catch {
                print("Error fetching schedual between stations: \(error)")
            }
        }
    }
    
    private func testStationSchedule(client: Client) {
        Task {
            do {
                let service = StationScheduleService(
                    client: client,
                    apikey: Constants.apiKey
                )
                
                print("Fetching schedual between stations...")
                let schedule = try await service.getStationSchedule(
                    station: "s9600213",
                    date: "2026-08-01"
                )
                
                print("Successfully fetched station schedule: \(schedule)")
            } catch {
                print("Error fetching station schedule: \(error)")
            }
        }
    }
    
    private func testRouteStations(client: Client) {
        Task {
            do {
                let service = RouteStationsService(
                    client: client,
                    apikey: Constants.apiKey
                )
                
                print("Fetching route stations...")
                let stations = try await service.getRouteStations(
                    uid: "038AA_tis",
                    date: "2026-08-01"
                )
                
                print("Successfully fetched route stations: \(stations)")
            } catch {
                print("Error route stations: \(error)")
            }
        }
    }
    
    private func testNearestCity(client: Client) {
        Task {
            do {
                let service = NearestCityService(
                    client: client,
                    apikey: Constants.apiKey
                )
                
                print("Fetching nearest city...")
                let city = try await service.getNearestCity(
                    lat: 50.440046,
                    lng: 40.4882367,
                    distance: 50
                )
                
                print("Successfully nearest city: \(city)")
            } catch {
                print("Error fetching nearest city: \(error)")
            }
        }
    }
    
    private func testCarrierInfo(client: Client) {
        Task {
            do {
                let service = CarrierInfoService(
                    client: client,
                    apikey: Constants.apiKey
                )
                
                print("Fetching carrier info...")
                let info = try await service.getCarrierInfo(
                    code: "TK"
                )
                
                print("Successfully carrier info: \(info)")
            } catch {
                print("Error fetching carrier info: \(error)")
            }
        }
    }
    
    private func testAllStations(client: Client) {
        Task {
            do {
                let service = AllStationsService(
                    client: client,
                    apikey: Constants.apiKey
                )
                
                print("Fetching all stations...")
                let stations = try await service.getAllStations()
                
                print("Successfully fetched all stations: \(stations)")
            } catch {
                print("Error fetching all stations: \(error)")
            }
        }
    }
    
    private func testCopyright(client: Client) {
        Task {
            do {
                let service = CopyrightService(
                    client: client,
                    apikey: Constants.apiKey
                )
                
                print("Fetching copyright...")
                let copyright = try await service.getCopyright()
                
                print("Successfully fetched copyright: \(copyright)")
            } catch {
                print("Error fetching copyright: \(error)")
            }
        }
    }
}

#Preview {
    ContentView()
}
