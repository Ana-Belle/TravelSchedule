//
//  SettingsView.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 02.08.2026.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        Color.whiteDayNight
            .ignoresSafeArea()
            .overlay {
                VStack {
                    Image("Settings")
                    Text("Настройки")
                }
                .padding()
            }
    }
}

#Preview {
    SettingsView()
}
