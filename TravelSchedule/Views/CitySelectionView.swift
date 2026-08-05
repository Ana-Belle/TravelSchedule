//
//  CitySelectionView.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 04.08.2026.
//

import SwiftUI

struct CitySelectionView: View {
    let field: StationField
    @Binding var fromStationTitle: String
    @Binding var toStationTitle: String
    @Binding var navigationPath: NavigationPath

    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @State private var viewModel = CitySelectionViewModel()

    private var filteredCities: [City] {
        viewModel.filteredCities(searchText: searchText)
    }

    private var isSearchActive: Bool {
        !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        citySelectionContent
    }

    private var citySelectionContent: some View {
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
                } else if filteredCities.isEmpty && isSearchActive {
                    Text("Город не найден")
                        .foregroundStyle(.blackDayNight)
                        .font(.system(size: 24, weight: .bold))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(filteredCities) { city in
                        NavigationLink(value: StationRoute(city: city, field: field)) {
                            Text(city.title)
                                .foregroundStyle(.blackDayNight)
                                .font(.system(size: 17, weight: .regular))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .frame(height: 60)
                        }
                        .listRowBackground(Color.whiteDayNight)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.whiteDayNight)
        .navigationTitle("Выбор города")
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
            await viewModel.loadCities()
        }
    }
}

#Preview {
    @Previewable @State var fromStationTitle = StationField.from.placeholder
    @Previewable @State var toStationTitle = StationField.to.placeholder
    @Previewable @State var navigationPath = NavigationPath()

    NavigationStack {
        CitySelectionView(
            field: .from,
            fromStationTitle: $fromStationTitle,
            toStationTitle: $toStationTitle,
            navigationPath: $navigationPath
        )
    }
}
