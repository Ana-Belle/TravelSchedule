//
//  MainTabViewPreview.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 17.08.2026.
//

import SwiftUI

struct MainTabViewPreview: View {
    init() {
        _ = APIServices.bootstrap()
    }

    var body: some View {
        MainTabView()
    }
}
