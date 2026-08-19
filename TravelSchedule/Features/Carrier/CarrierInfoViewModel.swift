//
//  CarrierInfoViewModel.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 17.08.2026.
//

import Foundation

@MainActor
@Observable
final class CarrierInfoViewModel {
    var carrier: Carrier?
    var isLoading = false
    var errorState: AppErrorState?
    
    private let carrierCode: String
    private let carrierInfoService: CarrierInfoServiceProtocol
    
    init(
        carrierCode: String,
        carrierInfoService: CarrierInfoServiceProtocol = APIServices.shared.carrierInfo
    ) {
        self.carrierCode = carrierCode
        self.carrierInfoService = carrierInfoService
    }
    
    func loadCarrierInfo() async {
        isLoading = true
        errorState = nil
        
        defer { isLoading = false }
        
        do {
            let response = try await carrierInfoService.getCarrierInfo(code: carrierCode)
            guard let apiCarrier = response.carrier ?? response.carriers?.first else { return }
            carrier = Carrier(from: apiCarrier, fallbackCode: carrierCode)
        } catch {
            errorState = AppErrorState(error: error)
        }
    }
}
