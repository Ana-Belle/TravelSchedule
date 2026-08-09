//
//  ErrorStateView.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 09.08.2026.
//

import SwiftUI

struct ErrorStateView: View {
    let kind: AppErrorState

    var body: some View {
        VStack(spacing: 16) {
            Image(kind.imageName)

            Text(kind.title)
                .foregroundStyle(.blackDayNight)
                .font(.system(size: 24, weight: .bold))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.whiteDayNight)
    }
}

#Preview("Server Error") {
    ErrorStateView(kind: .serverError)
}

#Preview("No Internet") {
    ErrorStateView(kind: .noInternet)
}
