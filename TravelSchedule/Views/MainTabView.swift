//
//  MainTabView.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 02.08.2026.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Image("Schedule")
                }

            SettingsView()
                .tabItem {
                    Image("Settings")
                }
        }
    }
}

#Preview {
    MainTabView()
}
