//
//  WKWebView+Async.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 20.08.2026.
//

import WebKit

extension WKWebView {
    func evaluateJavaScriptAsync(_ javaScriptString: String) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            evaluateJavaScript(javaScriptString) { _, error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }
}
