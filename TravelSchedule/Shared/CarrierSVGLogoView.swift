//
//  CarrierSVGLogoView.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 19.08.2026.
//

import SwiftUI
import WebKit

struct CarrierSVGLogoView: View {
    let urlString: String
    var size: CGFloat = 38
    var fillsSquare: Bool = false

    var body: some View {
        if let url = RemoteURL.normalized(from: urlString) {
            CarrierSVGWebView(url: url, fillsSquare: fillsSquare)
                .frame(width: size, height: size)
        }
    }
}

private struct CarrierSVGWebView: UIViewRepresentable {
    let url: URL
    let fillsSquare: Bool

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.backgroundColor = .clear
        webView.isUserInteractionEnabled = false
        loadContent(into: webView)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        loadContent(into: uiView)
    }

    private func loadContent(into webView: WKWebView) {
        if fillsSquare {
            webView.loadHTMLString(Self.html(for: url), baseURL: url)
        } else {
            webView.load(URLRequest(url: url))
        }
    }

    private static func html(for url: URL) -> String {
        """
        <!DOCTYPE html>
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">
        <style>
        * { margin: 0; padding: 0; }
        html, body { width: 100%; height: 100%; background: transparent; overflow: hidden; }
        img { width: 100%; height: 100%; object-fit: fill; display: block; }
        </style>
        </head>
        <body><img src="\(url.absoluteString)"></body>
        </html>
        """
    }
}

enum RemoteURL {
    static func normalized(from string: String) -> URL? {
        if string.hasPrefix("//") {
            return URL(string: "https:" + string)
        }

        return URL(string: string)
    }
}
