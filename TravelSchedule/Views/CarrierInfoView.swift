//
//  CarrierInfoView.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 12.08.2026.
//

import SwiftUI

struct CarrierInfoView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Color.whiteDayNight
            .ignoresSafeArea()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Информация о перевозчике")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(.blackDayNight)
                }

                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                    }
                }
            }
    }
}

#Preview {
    NavigationStack {
        CarrierInfoView()
    }
}
