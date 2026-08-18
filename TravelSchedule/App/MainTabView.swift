//
//  MainTabView.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 02.08.2026.
//

import SwiftUI

struct MainTabView: View {
    @Environment(SettingsViewModel.self) private var settingsViewModel

    init() {
        Self.configureTabBarAppearance()
    }

    private static func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .whiteDayNight
        appearance.stackedLayoutAppearance.normal.iconColor = .grayUniversal
        appearance.stackedLayoutAppearance.selected.iconColor = .blackDayNight
        appearance.inlineLayoutAppearance.normal.iconColor = .grayUniversal
        appearance.inlineLayoutAppearance.selected.iconColor = .blackDayNight
        appearance.compactInlineLayoutAppearance.normal.iconColor = .grayUniversal
        appearance.compactInlineLayoutAppearance.selected.iconColor = .blackDayNight

        configureTabBarColors(appearance)
    }

    private static func configureTabBarColors(_ appearance: UITabBarAppearance) {
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().unselectedItemTintColor = .grayUniversal
        UITabBar.appearance().tintColor = .blackDayNight
    }
    
    var body: some View {
        TabView {
            MainView()
                .tabItem {
                    Image("Schedule")
                        .renderingMode(.template)
                }
            
            SettingsView()
                .tabItem {
                    Image("Settings")
                        .renderingMode(.template)
                }
        }
        .tint(.blackDayNight)
        .onChange(of: settingsViewModel.isDarkModeEnabled) { _, _ in
            Self.configureTabBarAppearance()
        }
    }
}

#Preview {
    MainTabViewPreview()
}

