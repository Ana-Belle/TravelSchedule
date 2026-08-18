//
//  SettingsViewModel.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 17.08.2026.
//

import SwiftUI

@Observable
final class SettingsViewModel {
    private static let darkModeKey = "isDarkModeEnabled"

    var isDarkModeEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isDarkModeEnabled, forKey: Self.darkModeKey)
        }
    }

    init() {
        isDarkModeEnabled = UserDefaults.standard.bool(forKey: Self.darkModeKey)
    }
}
