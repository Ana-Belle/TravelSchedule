//
//  StationField.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 05.08.2026.
//

import Foundation

enum StationField: Hashable {
    case from
    case to
    
    var placeholder: String {
        switch self {
        case .from:
            "Откуда"
        case .to:
            "Куда"
        }
    }
}
