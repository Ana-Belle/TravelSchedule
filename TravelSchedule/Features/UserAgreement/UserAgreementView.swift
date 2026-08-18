//
//  UserAgreementView.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 18.08.2026.
//

import SwiftUI

struct UserAgreementView: View {
    private static let agreementURL = URL(string: "https://yandex.ru/legal/practicum_offer/ru/")!

    @State private var isLoading = true
    @State private var errorState: AppErrorState?

    var body: some View {
        Group {
            if let errorState {
                ErrorStateView(kind: errorState)
            } else {
                ZStack {
                    UserAgreementWebView(
                        url: Self.agreementURL,
                        isLoading: $isLoading,
                        onError: { error in
                            errorState = AppErrorState(error: error)
                        }
                    )

                    if isLoading {
                        ProgressView()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.whiteDayNight)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .navigationScreenToolbar(title: "Пользовательское соглашение")
    }
}

#Preview {
    NavigationStack {
        UserAgreementView()
    }
}
