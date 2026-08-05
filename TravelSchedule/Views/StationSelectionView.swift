//
//  StationSelectionView.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 05.08.2026.
//

import SwiftUI

struct StationSelectionView: View {
    let city: City
    let field: StationField
    @Binding var fromStation: String?
    @Binding var toStation: String?
    @Binding var navigationPath: NavigationPath

    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @State private var viewModel: StationSelectionViewModel

    init(
        city: City,
        field: StationField,
        fromStation: Binding<String?>,
        toStation: Binding<String?>,
        navigationPath: Binding<NavigationPath>
    ) {
        self.city = city
        self.field = field
        _fromStation = fromStation
        _toStation = toStation
        _navigationPath = navigationPath
        _viewModel = State(initialValue: StationSelectionViewModel(city: city))
    }

    private var filteredStations: [Station] {
        viewModel.filteredStations(searchText: searchText)
    }

    private var isSearchActive: Bool {
        !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.grayUniversal)

                TextField(
                    "",
                    text: $searchText,
                    prompt: Text("Введите запрос")
                        .foregroundStyle(.grayUniversal)
                        .font(.system(size: 17, weight: .regular))
                )
                .font(.system(size: 17, weight: .regular))
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 13)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.lightGray)
            }
            .padding(.horizontal, 16)

            if filteredStations.isEmpty && isSearchActive {
                Text("Станция не найдена")
                    .foregroundStyle(.blackDayNight)
                    .font(.system(size: 24, weight: .bold))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(filteredStations) { station in
                    Button {
                        selectStation(station)
                    } label: {
                        Text(station.title)
                            .foregroundStyle(.blackDayNight)
                            .font(.system(size: 17, weight: .regular))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(height: 60)
                    }
                    .buttonStyle(.plain)
                    .listRowBackground(Color.whiteDayNight)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.whiteDayNight)
        .navigationTitle("Выбор станции")
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
    }

    private func selectStation(_ station: Station) {
        switch field {
        case .from:
            fromStation = station.title
        case .to:
            toStation = station.title
        }

        navigationPath = NavigationPath()
    }
}

#Preview {
    @Previewable @State var fromStation: String?
    @Previewable @State var toStation: String?
    @Previewable @State var navigationPath = NavigationPath()

    NavigationStack {
        StationSelectionView(
            city: City(
                id: "c213",
                title: "Москва",
                stations: [
                    Station(id: "s9600213", title: "Москва Ярославская"),
                    Station(id: "s2000002", title: "Москва Казанская")
                ]
            ),
            field: .from,
            fromStation: $fromStation,
            toStation: $toStation,
            navigationPath: $navigationPath
        )
    }
}
