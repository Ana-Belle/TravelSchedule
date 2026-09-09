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
            backgroundView
        }
    }
    
    private var backgroundView: some View {
        Color.whiteDayNight
            .ignoresSafeArea()
            .overlay(alignment: .topLeading) {
                contentView
            }
    }
    
    private var contentView: some View {
        VStack(spacing: 32) {
            themeSection
            agreementSection
            Spacer()
            footerSection
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.horizontal, 16)
        .padding(.top, 19)
        .padding(.bottom, 24)
    }
    
    private var themeSection: some View {
        HStack {
            Text("Тёмная тема")
                .foregroundStyle(.blackDayNight)
                .font(.system(size: 17, weight: .regular))
            
            Spacer()
            
            Toggle("", isOn: Bindable(viewModel).isDarkModeEnabled)
                .labelsHidden()
                .tint(viewModel.isDarkModeEnabled ? .blueUniversal : .blackDayNight)
        }
    }
    
    private var agreementSection: some View {
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
    }
    
    private var footerSection: some View {
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
}

#Preview {
    NavigationStack {
        SettingsView()
            .environment(SettingsViewModel())
    }
}
