//
//  NavigationToolbar.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 17.08.2026.
//

import SwiftUI

struct NavigationToolbarTitle: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.system(size: 17, weight: .bold))
            .foregroundStyle(.blackDayNight)
    }
}

struct NavigationBackButton: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.backward")
        }
    }
}

extension View {
    func navigationScreenToolbar(title: String? = nil) -> some View {
        navigationBarBackButtonHidden(true)
            .toolbar {
                if let title {
                    ToolbarItem(placement: .principal) {
                        NavigationToolbarTitle(title: title)
                    }
                }

                ToolbarItem(placement: .topBarLeading) {
                    NavigationBackButton()
                }
            }
    }
}
