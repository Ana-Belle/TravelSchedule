//
//  UserAgreementWebView.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 18.08.2026.
//

import SwiftUI
import WebKit

struct UserAgreementWebView: UIViewRepresentable {
    let url: URL
    @Binding var isLoading: Bool
    var onError: (Error) -> Void
    
    func makeCoordinator() -> Coordinator {
        Coordinator(isLoading: $isLoading, onError: onError)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        webView.load(URLRequest(url: url))
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
    
    final class Coordinator: NSObject, WKNavigationDelegate {
        @Binding var isLoading: Bool
        let onError: (Error) -> Void
        
        init(isLoading: Binding<Bool>, onError: @escaping (Error) -> Void) {
            _isLoading = isLoading
            self.onError = onError
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            isLoading = true
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript(Self.hideChromeCSS) { _, _ in
                self.isLoading = false
            }
        }
        
        func webView(
            _ webView: WKWebView,
            didFail navigation: WKNavigation!,
            withError error: Error
        ) {
            isLoading = false
            onError(error)
        }
        
        func webView(
            _ webView: WKWebView,
            didFailProvisionalNavigation navigation: WKNavigation!,
            withError error: Error
        ) {
            isLoading = false
            onError(error)
        }
        
        private static let hideChromeCSS = """
        (function() {
            var style = document.createElement('style');
            style.textContent = `
                .Layout__header,
                .Layout__footer,
                .pc-layout__navigation,
                .pc-navigation,
                .pc-desktop-navigation__wrapper,
                .pc-logo,
                .dc-doc-page__aside,
                .dc-subnavigation,
                .HeaderControls,
                .dc-doc-page__controls,
                .dc-mini-toc,
                .dc-doc-page__page-contributors,
                .dc-doc-page__under-title-info {
                    display: none !important;
                }
                .Layout__content,
                .Layout__body,
                .dc-doc-layout,
                .dc-doc-page__main,
                .dc-doc-page__content,
                .pc-page-constructor__wrapper,
                .pc-layout {
                    padding: 0 !important;
                    margin: 0 !important;
                    max-width: 100% !important;
                }
                body {
                    padding: 16px !important;
                }
            `;
            document.head.appendChild(style);
        })();
        """
    }
}
