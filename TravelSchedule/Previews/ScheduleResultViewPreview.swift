//
//  ScheduleResultViewPreview.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 17.08.2026.
//

import SwiftUI

struct ScheduleResultViewPreview: View {
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
