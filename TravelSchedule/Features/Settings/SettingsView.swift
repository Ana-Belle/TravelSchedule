//
//  SettingsView.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 02.08.2026.
//

import SwiftUI

struct SettingsView: View {
    @Environment(SettingsViewModel.self) private var viewModel

    var body: some View {
        NavigationStack {
            Color.whiteDayNight
                .ignoresSafeArea()
                .overlay(alignment: .topLeading) {
                    VStack(spacing: 32) {
                        HStack {
                            Text("Тёмная тема")
                                .foregroundStyle(.blackDayNight)
                                .font(.system(size: 17, weight: .regular))

                            Spacer()

                            Toggle("", isOn: Bindable(viewModel).isDarkModeEnabled)
                                .labelsHidden()
                                .tint(viewModel.isDarkModeEnabled ? .blueUniversal : .blackDayNight)
                        }

                        NavigationLink {
                            UserAgreementView()
                        } label: {
                            HStack {
                                Text("Пользовательское соглашение")
                                    .foregroundStyle(.blackDayNight)
                                    .font(.system(size: 17, weight: .regular))

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .font(.system(size: 24))
                                    .foregroundStyle(.blackDayNight)
                            }
                        }
                        .buttonStyle(.plain)

                        Spacer()

                        VStack(spacing: 16) {
                            Text("Приложение использует API «Яндекс.Расписания»")
                                .foregroundStyle(.blackDayNight)
                                .font(.system(size: 12, weight: .regular))
                                .multilineTextAlignment(.center)

                            Text("Версия 1.0 (beta)")
                                .foregroundStyle(.blackDayNight)
                                .font(.system(size: 12, weight: .regular))
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding(.horizontal, 16)
                    .padding(.top, 19)
                    .padding(.bottom, 24)
                }
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
            .environment(SettingsViewModel())
    }
}
