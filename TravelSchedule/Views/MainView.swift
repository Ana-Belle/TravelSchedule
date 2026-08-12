//
//  MainView.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 03.08.2026.
//

import SwiftUI

private enum ScheduleDestination: Hashable {
    case citySelection(StationField)
}

struct MainView: View {
    @State private var navigationPath = NavigationPath()
    @State private var fromStation: Station?
    @State private var toStation: Station?
    
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
                .navigationDestination(for: ScheduleSearchRoute.self) { route in
                    ScheduleResultView(
                        fromStation: route.fromStation,
                        toStation: route.toStation
                    )
                }
        }
    }
    
    private var areStationsSelected: Bool {
        fromStation != nil && toStation != nil
    }
    
    private var scheduleContent: some View {
        GeometryReader { _ in
            
            Color.whiteDayNight
                .overlay(alignment: .top) {
                    VStack(spacing: 16) {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.blueUniversal)
                            .overlay {
                                HStack(spacing: 0) {
                                    Section {
                                        VStack {
                                            Section {
                                                NavigationLink(value: ScheduleDestination.citySelection(.from)) {
                                                    Text(fromStation?.title ?? StationField.from.placeholder)
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
                                                    Text(toStation?.title ?? StationField.to.placeholder)
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
                            .frame(height: 128)
                        
                        if areStationsSelected {
                            Button {
                                if let fromStation, let toStation {
                                    navigationPath.append(
                                        ScheduleSearchRoute(
                                            fromStation: fromStation,
                                            toStation: toStation
                                        )
                                    )
                                }
                            } label: {
                                Text("Найти")
                                    .font(.system(size: 17, weight: .bold))
                                    .foregroundStyle(.whiteUniversal)
                                    .frame(maxWidth: .infinity)
                                    .frame(width: 150, height: 60)
                                    .background(.blueUniversal, in: RoundedRectangle(cornerRadius: 16))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.top, 252)
                    .padding(.horizontal, 16)
                }
        }
        .ignoresSafeArea()
    }
    
    private func stationTitleColor(for field: StationField) -> Color {
        switch field {
        case .from:
            fromStation == nil ? .grayUniversal : .blackUniversal
        case .to:
            toStation == nil ? .grayUniversal : .blackUniversal
        }
    }
}

#Preview {
    MainView()
}
