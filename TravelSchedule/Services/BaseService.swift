//
//  BaseService.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 12.07.2026.
//

class BaseService {
    let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
}
