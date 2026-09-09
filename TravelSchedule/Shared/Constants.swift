//
//  Constants.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 12.07.2026.
//

import Foundation

enum Constants {
    static var apiKey: String {
        if let key = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String, !key.isEmpty {
            return key
        }
        
        if let bundle = Bundle(identifier: "ru.ana-belle.TravelSchedule"),
           let key = bundle.object(forInfoDictionaryKey: "API_KEY") as? String,
           !key.isEmpty {
            return key
        }
        
        return ""
    }
}
