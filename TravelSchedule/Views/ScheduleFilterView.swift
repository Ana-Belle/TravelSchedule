//
//  ScheduleFilterView.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 09.08.2026.
//

import SwiftUI

struct ScheduleFilterView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var filters: ScheduleFilters

    @State private var draftFilters: ScheduleFilters

    let onApply: (ScheduleFilters) -> Void

    init(filters: Binding<ScheduleFilters>, onApply: @escaping (ScheduleFilters) -> Void) {
        _filters = filters
        _draftFilters = State(initialValue: filters.wrappedValue)
        self.onApply = onApply
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Время отправления")
                            .foregroundStyle(.blackDayNight)
                            .font(.system(size: 24, weight: .bold))
                            .padding(.bottom, 16)

                        ForEach(DepartureTimePeriod.allCases) { period in
                            timePeriodRow(period)
                        }
                    }

                    VStack(alignment: .leading, spacing: 0) {
                        Text("Показывать варианты с пересадками")
                            .foregroundStyle(.blackDayNight)
                            .font(.system(size: 24, weight: .bold))
                            .padding(.bottom, 16)

                        transfersRow(title: "Да", value: .yes)
                        transfersRow(title: "Нет", value: .no)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 24)
                .padding(.bottom, draftFilters.hasActiveFilters ? 118 : 32)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .background(Color.whiteDayNight)

            if draftFilters.hasActiveFilters {
                applyButton
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }

    private var applyButton: some View {
        Button {
            filters = draftFilters
            onApply(draftFilters)
            dismiss()
        } label: {
            Text("Применить")
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(.whiteUniversal)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(.blueUniversal, in: RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 16)
        .padding(.bottom, 24)
    }

    private func timePeriodRow(_ period: DepartureTimePeriod) -> some View {
        Button {
            togglePeriod(period)
        } label: {
            HStack(spacing: 16) {
                Text("\(period.title) \(period.timeRange)")
                    .foregroundStyle(.blackDayNight)
                    .font(.system(size: 17, weight: .regular))

                Spacer()

                SquareCheckbox(isSelected: draftFilters.selectedPeriods.contains(period))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(minHeight: 60)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private func transfersRow(title: String, value: TransfersFilter) -> some View {
        Button {
            draftFilters.transfers = value
        } label: {
            HStack(spacing: 16) {
                Text(title)
                    .foregroundStyle(.blackDayNight)
                    .font(.system(size: 17, weight: .regular))

                Spacer()

                RadioButton(isSelected: draftFilters.transfers == value)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(minHeight: 60)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private func togglePeriod(_ period: DepartureTimePeriod) {
        if draftFilters.selectedPeriods.contains(period) {
            draftFilters.selectedPeriods.remove(period)
        } else {
            draftFilters.selectedPeriods.insert(period)
        }
    }
}

private struct SquareCheckbox: View {
    let isSelected: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .stroke(.blackDayNight, lineWidth: 1.5)
                .frame(width: 22, height: 22)

            if isSelected {
                Image(systemName: "checkmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.blackDayNight)
            }
        }
    }
}

private struct RadioButton: View {
    let isSelected: Bool

    var body: some View {
        ZStack {
            Circle()
                .stroke(.blackDayNight, lineWidth: 1.5)
                .frame(width: 22, height: 22)

            if isSelected {
                Circle()
                    .fill(.blackDayNight)
                    .frame(width: 12, height: 12)
            }
        }
    }
}

#Preview {
    @Previewable @State var filters = ScheduleFilters()

    NavigationStack {
        ScheduleFilterView(filters: $filters) { _ in }
    }
}
