//
//  ScheduleView.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 03.08.2026.
//

import SwiftUI

private enum ScheduleDestination: Hashable {
    case citySelection(StationField)
}

struct ScheduleView: View {
    @State private var navigationPath = NavigationPath()
    @State private var fromStation: String?
    @State private var toStation: String?

    var body: some View {
        NavigationStack(path: $navigationPath) {
            scheduleContent
                .navigationDestination(for: ScheduleDestination.self) { destination in
                    switch destination {
                    case .citySelection(let field):
                        CitySelectionView(
                            field: field,
                            fromStation: $fromStation,
                            toStation: $toStation,
                            navigationPath: $navigationPath
                        )
                    }
                }
                .navigationDestination(for: StationRoute.self) { route in
                    StationSelectionView(
                        city: route.city,
                        field: route.field,
                        fromStation: $fromStation,
                        toStation: $toStation,
                        navigationPath: $navigationPath
                    )
                }
        }
    }

    private var scheduleContent: some View {
        GeometryReader { _ in

            Color.whiteDayNight
                .overlay(alignment: .top) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.blueUniversal)
                        .overlay {
                            HStack(spacing: 0) {
                                Section {
                                    VStack {
                                        Section {
                                            NavigationLink(value: ScheduleDestination.citySelection(.from)) {
                                                Text(fromStation ?? StationField.from.placeholder)
                                                    .foregroundStyle(stationTitleColor(for: .from))
                                                    .font(.system(size: 17, weight: .regular))
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .contentShape(Rectangle())
                                            }
                                            .buttonStyle(.plain)
                                            .padding(.top, 14)
                                        }
                                        Section {
                                            NavigationLink(value: ScheduleDestination.citySelection(.to)) {
                                                Text(toStation ?? StationField.to.placeholder)
                                                    .foregroundStyle(stationTitleColor(for: .to))
                                                    .font(.system(size: 17, weight: .regular))
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .contentShape(Rectangle())
                                            }
                                            .buttonStyle(.plain)
                                            .padding(.top, 14)
                                        }
                                    }
                                    .padding(.leading, 16)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                    .background {
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(.whiteUniversal)
                                    }
                                }

                                Section {
                                    Button {
                                        swap(&fromStation, &toStation)
                                    } label: {
                                        Image("Change")
                                            .frame(width: 36, height: 36)
                                            .background(.whiteUniversal, in: Circle())
                                    }
                                    .buttonStyle(.plain)
                                    .padding(.leading, 16)
                                    .padding(.trailing, 16)
                                }
                            }
                            .padding(.leading, 16)
                            .padding(.top, 16)
                            .padding(.bottom, 16)
                        }
                        .frame(
                            height: 128
                        )
                        .padding(.top, 252)
                        .padding(.leading, 16)
                        .padding(.trailing, 16)
                }
        }
        .ignoresSafeArea()
    }

    private func stationTitleColor(for field: StationField) -> Color {
        switch field {
        case .from:
            fromStation == nil ? .grayUniversal : .blackDayNight
        case .to:
            toStation == nil ? .grayUniversal : .blackDayNight
        }
    }
}

#Preview {
    ScheduleView()
}
