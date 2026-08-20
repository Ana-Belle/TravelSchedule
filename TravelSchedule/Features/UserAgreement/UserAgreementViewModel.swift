//
//  UserAgreementViewModel.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 20.08.2026.
//

import Foundation

@MainActor
@Observable
final class UserAgreementViewModel {
    let agreementURL: URL
    
    var isLoading = true
    var errorState: AppErrorState?
    
    init(
        agreementURL: URL = URL(string: "https://yandex.ru/legal/practicum_offer/ru/")!
    ) {
        self.agreementURL = agreementURL
    }
    
    func handleError(_ error: Error) {
        isLoading = false
        errorState = AppErrorState(error: error)
    }
}
