//
//  MainView.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 03.08.2026.
//

import SwiftUI

struct MainView: View {
    @State private var navigationPath = NavigationPath()
    @State private var fromStation: Station?
    @State private var toStation: Station?
    @State private var presentedStory: PresentedStory?
    @State private var storiesViewedStore = StoriesViewedStore()
    
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
        .fullScreenCover(item: $presentedStory) { story in
            StoriesScreenView(initialIndex: story.id)
                .environment(storiesViewedStore)
        }
    }
    
    private var areStationsSelected: Bool {
        fromStation != nil && toStation != nil
    }
    
    private var scheduleContent: some View {
        GeometryReader { _ in
            
            Color.whiteDayNight
                .overlay(alignment: .top) {
                    VStack(spacing: 0) {
                        storiesRow
                        stationSelectionCard
                            .padding(.top, 44)
                        searchButton
                            .padding(.top, 16)
                    }
                    .padding(.top, 96)
                    .padding(.horizontal, 16)
                }
        }
        .ignoresSafeArea()
    }
    
    private var storiesRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(StoriesContent.stories) { story in
                    Button {
                        presentedStory = PresentedStory(id: story.id)
                    } label: {
                        storyPreview(for: story)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    @ViewBuilder
    private func storyPreview(for story: Story) -> some View {
        let isViewed = storiesViewedStore.isViewed(story.id)
        
        Image(story.imageName)
            .resizable()
            .scaledToFill()
            .frame(width: 92, height: 140)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(alignment: .bottom) {
                Text(story.title)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(.whiteUniversal)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8)
            }
            .overlay {
                if !isViewed {
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(.blueUniversal, lineWidth: 4)
                }
            }
            .opacity(isViewed ? 0.5 : 1)
    }
    
    private var stationSelectionCard: some View {
        HStack(spacing: 0) {
            VStack {
                stationLink(for: .from)
                stationLink(for: .to)
            }
            .padding(.leading, 16)
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .topLeading
            )
            .background(
                .whiteUniversal,
                in: RoundedRectangle(cornerRadius: 20)
            )
            
            swapStationsButton
        }
        .padding(16)
        .frame(height: 128)
        .background(
            .blueUniversal,
            in: RoundedRectangle(cornerRadius: 20)
        )
    }
    
    private func stationLink(
        for field: StationField
    ) -> some View {
        NavigationLink(
            value: ScheduleDestination.citySelection(field)
        ) {
            Text(stationTitle(for: field))
                .foregroundStyle(stationTitleColor(for: field))
                .font(.system(size: 17, weight: .regular))
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .padding(.top, 14)
    }
    
    private func stationTitle(
        for field: StationField
    ) -> String {
        switch field {
        case .from:
            fromStation?.title ?? field.placeholder
        case .to:
            toStation?.title ?? field.placeholder
        }
    }
    
    private var swapStationsButton: some View {
        Button {
            swap(&fromStation, &toStation)
        } label: {
            Image("Change")
                .frame(width: 36, height: 36)
                .background(.whiteUniversal, in: Circle())
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    private var searchButton: some View {
        if let fromStation, let toStation {
            Button {
                navigationPath.append(
                    ScheduleSearchRoute(
                        fromStation: fromStation,
                        toStation: toStation
                    )
                )
            } label: {
                Text("Найти")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.whiteUniversal)
                    .frame(width: 150, height: 60)
                    .background(
                        .blueUniversal,
                        in: RoundedRectangle(cornerRadius: 16)
                    )
            }
            .buttonStyle(.plain)
        }
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

private struct PresentedStory: Identifiable {
    let id: Int
}
