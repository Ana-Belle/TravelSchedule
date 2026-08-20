//
//  UserAgreementView.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 18.08.2026.
//

import SwiftUI

struct UserAgreementView: View {
    @State private var viewModel = UserAgreementViewModel()
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
        Group {
            if let errorState = viewModel.errorState {
                ErrorStateView(kind: errorState)
            } else {
                ZStack {
                    UserAgreementWebView(
                        url: viewModel.agreementURL,
                        isLoading: $viewModel.isLoading,
                        onError: viewModel.handleError
                    )
                    
                    if viewModel.isLoading {
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
