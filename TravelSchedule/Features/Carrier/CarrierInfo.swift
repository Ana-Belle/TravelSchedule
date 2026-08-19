//
//  CarrierInfo.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 17.08.2026.
//

import Foundation
import OpenAPIRuntime

struct Carrier: Identifiable, Hashable {
    let id: String
    let title: String
    let logoURL: String?
    let logoSVGURL: String?
    let email: String?
    let phone: String?
    
    init(from apiCarrier: Components.Schemas.Carrier, fallbackCode: String) {
        id = apiCarrier.code.map(String.init) ?? fallbackCode
        title = apiCarrier.title ?? ""
        logoURL = apiCarrier.logo
        logoSVGURL = Self.nonEmpty(apiCarrier.logo_svg)
        email = Self.nonEmpty(apiCarrier.email) ?? Self.extractEmail(from: apiCarrier.contacts)
        phone = Self.nonEmpty(apiCarrier.phone) ?? Self.extractPhone(from: apiCarrier.contacts)
    }
    
    private static func nonEmpty(_ value: String?) -> String? {
        guard let value, !value.isEmpty else { return nil }
        return value
    }
    
    private static func extractEmail(from contacts: String?) -> String? {
        guard let contacts else { return nil }
        
        let normalized = contacts
            .replacingOccurrences(of: "<br />", with: " ")
            .replacingOccurrences(of: "<br/>", with: " ")
            .replacingOccurrences(of: "<br>", with: " ")
            .replacingOccurrences(of: "\r\n", with: " ")
        
        guard let range = normalized.range(
            of: #"[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}"#,
            options: [.regularExpression, .caseInsensitive]
        ) else { return nil }
        
        return String(normalized[range])
    }
    
    private static func extractPhone(from contacts: String?) -> String? {
        guard let contacts else { return nil }
        
        let normalized = contacts
            .replacingOccurrences(of: "<br />", with: " ")
            .replacingOccurrences(of: "<br/>", with: " ")
            .replacingOccurrences(of: "<br>", with: " ")
            .replacingOccurrences(of: "\r\n", with: " ")
        
        guard let range = normalized.range(
            of: #"\+?\d[\d\s()-]{8,}\d"#,
            options: .regularExpression
        ) else { return nil }
        
        return String(normalized[range]).trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
