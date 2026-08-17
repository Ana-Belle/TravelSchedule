//
//  CarrierInfoView.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 12.08.2026.
//

import SwiftUI

struct CarrierInfoView: View {
    var body: some View {
        Color.whiteDayNight
            .ignoresSafeArea()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
            .navigationScreenToolbar(title: "Информация о перевозчике")
    }
}

#Preview {
    NavigationStack {
        CarrierInfoView()
    }
}
