//
//  ScheduleResultView.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 06.08.2026.
//

import SwiftUI

struct ScheduleResultView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: ScheduleResultViewModel

    init(fromStation: Station, toStation: Station) {
        _viewModel = State(
            initialValue: ScheduleResultViewModel(
                fromStation: fromStation,
                toStation: toStation
            )
        )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(viewModel.routeTitle)
                .foregroundStyle(.blackDayNight)
                .font(.system(size: 24, weight: .bold))
                .padding(.horizontal, 16)
                .padding(.top, 16)

            Group {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.grayUniversal)
                        .font(.system(size: 17, weight: .regular))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.scheduleItems.isEmpty {
                    Text("Вариантов нет")
                        .foregroundStyle(.blackDayNight)
                        .font(.system(size: 24, weight: .bold))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(viewModel.scheduleItems) { item in
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(alignment: .top, spacing: 12) {
                                CarrierLogoView(logoURL: item.logoURL)

                                HStack(alignment: .top, spacing: 8) {
                                    Text(item.carrierTitle)
                                        .foregroundStyle(.blackUniversal)
                                        .font(.system(size: 17, weight: .regular))

                                    Spacer(minLength: 8)

                                    Text(item.departureDate)
                                        .foregroundStyle(.blackUniversal)
                                        .font(.system(size: 12, weight: .regular))
                                }
                                .frame(maxWidth: .infinity, minHeight: 38, alignment: .center)
                            }

                            HStack(spacing: 8) {
                                Text(item.departureTime)
                                    .foregroundStyle(.blackUniversal)
                                    .font(.system(size: 17, weight: .regular))

                                scheduleConnectorLine

                                Text(item.durationText)
                                    .foregroundStyle(.blackUniversal)
                                    .font(.system(size: 12, weight: .regular))
                                    .fixedSize()

                                scheduleConnectorLine

                                Text(item.arrivalTime)
                                    .foregroundStyle(.blackUniversal)
                                    .font(.system(size: 17, weight: .regular))
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background {
                            RoundedRectangle(cornerRadius: 24)
                                .fill(.lightGray)
                        }
                        .listRowBackground(Color.whiteDayNight)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.whiteDayNight)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                }
            }
        }
        .task {
            await viewModel.loadSchedule()
        }
    }
}

private var scheduleConnectorLine: some View {
    Rectangle()
        .fill(.grayUniversal)
        .frame(height: 1)
        .frame(maxWidth: .infinity)
}

private struct CarrierLogoView: View {
    let logoURL: String?

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
        .frame(width: 38, height: 38)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var logoPlaceholder: some View {
        Image(systemName: "tram.fill")
            .foregroundStyle(.grayUniversal)
    }
}

#Preview {
    NavigationStack {
        ScheduleResultView(
            fromStation: Station(id: "s9600213", title: "Москва"),
            toStation: Station(id: "s9600366", title: "Санкт-Петербург")
        )
    }
}
