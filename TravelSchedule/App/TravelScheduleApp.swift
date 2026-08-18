//
//  TravelScheduleApp.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 08.07.2026.
//

import SwiftUI

@main
struct TravelScheduleApp: App {
    @State private var settingsViewModel = SettingsViewModel()
    private let isAPIAvailable: Bool

    init() {
        isAPIAvailable = APIServices.bootstrap()
    }

    var body: some Scene {
        WindowGroup {
            if isAPIAvailable {
                MainTabView()
                    .environment(settingsViewModel)
                    .preferredColorScheme(settingsViewModel.isDarkModeEnabled ? .dark : .light)
            } else {
                ErrorStateView(kind: .serverError)
            }
        }
    }
}
