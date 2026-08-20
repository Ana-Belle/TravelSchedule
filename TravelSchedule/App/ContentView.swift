//
//  ContentView.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 08.07.2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: SystemName.globe)
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
        guard APIServices.bootstrap() else { return }
        
        testFetchStations()
        testScheduleBetweenStations()
        testStationSchedule()
        testRouteStations()
        testNearestCity()
        testCarrierInfo()
        testAllStations()
        testCopyright()
    }
    
    private func testFetchStations() {
        Task {
            do {
                let service = APIServices.shared.nearestStations
                
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
    
    private func testScheduleBetweenStations() {
        Task {
            do {
                let service = APIServices.shared.scheduleBetweenStations
                
                print("Fetching schedule between stations...")
                let schedule = try await service.getScheduleBetweenStations(
                    from: "c146",
                    to: "c213",
                    date: "2026-08-01"
                )
                
                print("Successfully fetched schedule between stations: \(schedule)")
            } catch {
                print("Error fetching schedule between stations: \(error)")
            }
        }
    }
    
    private func testStationSchedule() {
        Task {
            do {
                let service = APIServices.shared.stationSchedule
                
                print("Fetching schedule between stations...")
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
    
    private func testRouteStations() {
        Task {
            do {
                let service = APIServices.shared.routeStations
                
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
    
    private func testNearestCity() {
        Task {
            do {
                let service = APIServices.shared.nearestCity
                
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
    
    private func testCarrierInfo() {
        Task {
            do {
                let service = APIServices.shared.carrierInfo
                
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
    
    private func testAllStations() {
        Task {
            do {
                let service = APIServices.shared.allStations
                
                print("Fetching all stations...")
                let stations = try await service.getAllStations()
                
                print("Successfully fetched all stations: \(stations)")
            } catch {
                print("Error fetching all stations: \(error)")
            }
        }
    }
    
    private func testCopyright() {
        Task {
            do {
                let service = APIServices.shared.copyright
                
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
