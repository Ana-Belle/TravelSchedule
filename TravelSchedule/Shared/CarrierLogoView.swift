//
//  CarrierLogoView.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 17.08.2026.
//

import SwiftUI

struct CarrierLogoView: View {
    let logoURL: String?
    var size: CGFloat = 38

    var body: some View {
        Group {
            if let logoURL, let url = URL(string: logoURL) {
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
