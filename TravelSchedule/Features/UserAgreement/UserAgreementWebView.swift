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
        webView.isOpaque = true
        webView.backgroundColor = .whiteDayNight
        webView.scrollView.backgroundColor = .whiteDayNight
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.backgroundColor = .whiteDayNight
        uiView.scrollView.backgroundColor = .whiteDayNight
        Self.applyStyles(to: uiView)
    }

    fileprivate static func applyStyles(to webView: WKWebView) {
        let textColor = UIColor.blackDayNight.resolvedColor(with: webView.traitCollection).cssRGB
        let backgroundColor = UIColor.whiteDayNight.resolvedColor(with: webView.traitCollection).cssRGB

        webView.evaluateJavaScript(styleScript(textColor: textColor, backgroundColor: backgroundColor))
    }

    private static func styleScript(textColor: String, backgroundColor: String) -> String {
        """
        (function() {
            var style = document.getElementById('travel-schedule-theme');
            if (!style) {
                style = document.createElement('style');
                style.id = 'travel-schedule-theme';
                document.head.appendChild(style);
            }
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
                    background-color: \(backgroundColor) !important;
                }
                html,
                body,
                .Layout,
                .Layout__body,
                .dc-doc-layout,
                .dc-doc-page,
                .dc-doc-page__main,
                .dc-doc-page__content,
                .pc-page-constructor__wrapper {
                    background-color: \(backgroundColor) !important;
                    color: \(textColor) !important;
                }
                body {
                    padding: 16px !important;
                }
                body,
                p,
                li,
                h1,
                h2,
                h3,
                h4,
                h5,
                h6,
                span,
                div,
                td,
                th,
                .dc-doc-page__title,
                .dc-doc-page__content,
                .yfm,
                .yfm *:not(a) {
                    color: \(textColor) !important;
                }
            `;
        })();
        """
    }

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
            UserAgreementWebView.applyStyles(to: webView)
            isLoading = false
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
    }
}

private extension UIColor {
    var cssRGB: String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return String(
            format: "rgb(%d, %d, %d)",
            Int(red * 255),
            Int(green * 255),
            Int(blue * 255)
        )
    }
}
