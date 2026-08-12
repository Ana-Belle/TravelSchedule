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
        @Bindable var viewModel = viewModel

        Group {
            if let errorState = viewModel.errorState {
                ErrorStateView(kind: errorState)
            } else {
                scheduleContent
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.whiteDayNight)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(viewModel.errorState == nil ? .hidden : .visible, for: .tabBar)
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
        .navigationDestination(isPresented: $viewModel.isFilterPresented) {
            ScheduleFilterView(filters: $viewModel.filters) { appliedFilters in
                viewModel.applyFilters(appliedFilters)
            }
        }
        .task {
            await viewModel.loadSchedule()
        }
    }

    private var scheduleContent: some View {
        @Bindable var viewModel = viewModel

        return VStack(alignment: .leading, spacing: 16) {
            Text(viewModel.routeTitle)
                .foregroundStyle(.blackDayNight)
                .font(.system(size: 24, weight: .bold))
                .padding(.horizontal, 16)
                .padding(.top, 16)

            Group {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.scheduleItems.isEmpty && !viewModel.hasLoadedSchedule {
                    Text("Вариантов нет")
                        .foregroundStyle(.blackDayNight)
                        .font(.system(size: 24, weight: .bold))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ZStack(alignment: .bottom) {
                        Group {
                            if viewModel.scheduleItems.isEmpty {
                                Text("Вариантов нет")
                                    .foregroundStyle(.blackDayNight)
                                    .font(.system(size: 24, weight: .bold))
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            } else {
                                List {
                                    ForEach(viewModel.scheduleItems) { item in
                                        scheduleItemRow(item)
                                            .onAppear {
                                                guard item.id == viewModel.scheduleItems.last?.id else { return }
                                                Task {
                                                    await viewModel.loadMoreIfNeeded()
                                                }
                                            }
                                    }

                                    if viewModel.isLoadingMore {
                                        HStack {
                                            Spacer()
                                            ProgressView()
                                            Spacer()
                                        }
                                        .listRowBackground(Color.whiteDayNight)
                                        .listRowSeparator(.hidden)
                                    }
                                }
                                .listStyle(.plain)
                                .scrollContentBackground(.hidden)
                                .contentMargins(.bottom, 118, for: .scrollContent)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.whiteDayNight)

                        filterButton
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private var filterButton: some View {
        Button {
            viewModel.isFilterPresented = true
        } label: {
            HStack(spacing: 8) {
                Text("Уточнить время")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.whiteUniversal)

                if viewModel.filters.hasActiveFilters {
                    Circle()
                        .fill(.redUniversal)
                        .frame(width: 8, height: 8)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(.blueUniversal, in: RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 16)
        .padding(.bottom, 24)
    }

    private func scheduleItemRow(_ item: ScheduleItem) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                CarrierLogoView(logoURL: item.logoURL)

                HStack(alignment: .top, spacing: 8) {
                    Group {
                        if let transferCity = item.transferCity {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.carrierTitle)
                                    .foregroundStyle(.blackUniversal)
                                    .font(.system(size: 17, weight: .regular))

                                Text("С пересадкой в \(transferCity)")
                                    .foregroundStyle(.redUniversal)
                                    .font(.system(size: 12, weight: .regular))
                            }
                        } else {
                            Text(item.carrierTitle)
                                .foregroundStyle(.blackUniversal)
                                .font(.system(size: 17, weight: .regular))
                                .frame(height: 38, alignment: .center)
                        }
                    }

                    Spacer(minLength: 8)

                    Text(item.departureDate)
                        .foregroundStyle(.blackUniversal)
                        .font(.system(size: 12, weight: .regular))
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
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

#Preview {
    ScheduleResultViewPreview()
}

private struct ScheduleResultViewPreview: View {
    init() {
        _ = APIServices.bootstrap()
    }

    var body: some View {
        NavigationStack {
            ScheduleResultView(
                fromStation: Station(id: "s9600213", title: "Москва"),
                toStation: Station(id: "s9600366", title: "Санкт-Петербург")
            )
        }
    }
}
