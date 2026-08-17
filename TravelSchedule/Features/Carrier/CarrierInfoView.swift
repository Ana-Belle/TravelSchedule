//
//  CarrierInfoView.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 12.08.2026.
//

import SwiftUI

struct CarrierInfoView: View {
    @State private var viewModel: CarrierInfoViewModel

    init(carrierCode: String) {
        _viewModel = State(initialValue: CarrierInfoViewModel(carrierCode: carrierCode))
    }

    var body: some View {
        Group {
            if let errorState = viewModel.errorState {
                ErrorStateView(kind: errorState)
            } else if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let carrier = viewModel.carrier {
                carrierContent(carrier)
            } else {
                Text("Информация недоступна")
                    .foregroundStyle(.blackDayNight)
                    .font(.system(size: 24, weight: .bold))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.whiteDayNight)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .navigationScreenToolbar(title: "Информация о перевозчике")
        .task {
            await viewModel.loadCarrierInfo()
        }
    }

    private func carrierContent(_ carrier: Carrier) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                carrierLogo(carrier.logoURL)

                VStack(alignment: .leading, spacing: 0) {
                    if !carrier.title.isEmpty {
                        Text(carrier.title)
                            .foregroundStyle(.blackDayNight)
                            .font(.system(size: 24, weight: .bold))
                    }

                    if let email = carrier.email, !email.isEmpty {
                        infoRow(title: "E-mail", value: email)
                            .padding(.top, carrier.title.isEmpty ? 0 : 28)
                    }

                    if let phone = carrier.phone, !phone.isEmpty {
                        infoRow(title: "Телефон", value: phone)
                            .padding(.top, phoneTopPadding(for: carrier))
                    }
                }
                .padding(.horizontal, 16)
            }
            .padding(.top, 16)
            .padding(.bottom, 32)
        }
    }

    private func carrierLogo(_ logoURL: String?) -> some View {
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
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
    }

    private var logoPlaceholder: some View {
        Image(systemName: "tram.fill")
            .foregroundStyle(.grayUniversal)
            .frame(maxWidth: .infinity, minHeight: 80)
    }

    private func phoneTopPadding(for carrier: Carrier) -> CGFloat {
        if let email = carrier.email, !email.isEmpty {
            return 16
        }

        return carrier.title.isEmpty ? 0 : 28
    }

    private func infoRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .foregroundStyle(.blackDayNight)
                .font(.system(size: 17, weight: .regular))

            Text(value)
                .foregroundStyle(.blueUniversal)
                .font(.system(size: 12, weight: .regular))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    NavigationStack {
        CarrierInfoView(carrierCode: "26")
    }
}
