//
//  TravelScheduleApp.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 08.07.2026.
//

import SwiftUI

@main
struct TravelScheduleApp: App {
    private let isAPIAvailable: Bool

    init() {
        isAPIAvailable = APIServices.bootstrap()
    }

    var body: some Scene {
        WindowGroup {
            if isAPIAvailable {
                MainTabView()
            } else {
                ErrorStateView(kind: .serverError)
            }
        }
    }
}
