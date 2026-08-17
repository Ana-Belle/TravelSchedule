//
//  CitySelectionViewPreview.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 17.08.2026.
//

import SwiftUI

struct CitySelectionViewPreview: View {
    @State private var fromStation: Station?
    @State private var toStation: Station?
    @State private var navigationPath = NavigationPath()

    init() {
        _ = APIServices.bootstrap()
    }

    var body: some View {
        NavigationStack {
            CitySelectionView(
                field: .from,
                fromStation: $fromStation,
                toStation: $toStation,
                navigationPath: $navigationPath
            )
        }
    }
}
