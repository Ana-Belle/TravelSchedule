//
//  CarrierLogoView.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 17.08.2026.
//

import SwiftUI

struct CarrierLogoView: View {
    let logoSVGURL: String?
    let logoURL: String?
    var size: CGFloat = 38

    init(logoSVGURL: String?, logoURL: String? = nil, size: CGFloat = 38) {
        self.logoSVGURL = logoSVGURL
        self.logoURL = logoURL
        self.size = size
    }

    var body: some View {
        Group {
            if let logoSVGURL {
                CarrierSVGLogoView(urlString: logoSVGURL, size: size, fillsSquare: true)
            } else if let logoURL, let url = RemoteURL.normalized(from: logoURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                    case .failure:
                        logoPlaceholder
                    case .empty:
                        ProgressView()
                    @unknown default:
                        logoPlaceholder
                    }
                }
            } else {
                logoPlaceholder
            }
        }
        .frame(width: size, height: size)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(.whiteUniversal)
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var logoPlaceholder: some View {
        Image(systemName: "tram.fill")
            .foregroundStyle(.grayUniversal)
    }
}
