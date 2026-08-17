//
//  CitySelectionView.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 04.08.2026.
//

import SwiftUI

struct CitySelectionView: View {
    let field: StationField
    @Binding var fromStation: Station?
    @Binding var toStation: Station?
    @Binding var navigationPath: NavigationPath
    
    @State private var viewModel = CitySelectionViewModel()
    
    var body: some View {
        Group {
            if let errorState = viewModel.errorState {
                ErrorStateView(kind: errorState)
            } else {
                citySelectionContent
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.whiteDayNight)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(viewModel.errorState == nil ? .hidden : .visible, for: .tabBar)
        .navigationScreenToolbar(title: "Выбор города")
        .task {
            await viewModel.loadCities()
        }
    }
    
    private var citySelectionContent: some View {
        VStack(spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.grayUniversal)
                
                TextField(
                    "",
                    text: $viewModel.searchText,
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
                    .fill(.lightGraySearch)
            }
            .padding(.horizontal, 16)
            
            Group {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.filteredCities.isEmpty && viewModel.isSearchActive {
                    Text("Город не найден")
                        .foregroundStyle(.blackDayNight)
                        .font(.system(size: 24, weight: .bold))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(viewModel.filteredCities) { city in
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
    }
}

#Preview {
    CitySelectionViewPreview()
}

