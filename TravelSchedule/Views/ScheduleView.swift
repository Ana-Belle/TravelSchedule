//
//  ScheduleView.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 03.08.2026.
//

import SwiftUI

struct ScheduleView: View {
    var body: some View {
        GeometryReader { _ in
            
            Color.whiteDayNight
                .overlay(alignment: .top) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.blueUniversal)
                        .overlay {
                            HStack(spacing: 0) {
                                Section {
                                    VStack {
                                        Section {
                                            Button {} label: {
                                                Text("Откуда")
                                                    .foregroundStyle(.grayUniversal)
                                                    .font(.system(size: 17, weight: .regular))
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                            }
                                            .buttonStyle(.plain)
                                            .padding(.top, 14)
                                        }
                                        Section {
                                            Button {} label: {
                                                Text("Куда")
                                                    .foregroundStyle(.grayUniversal)
                                                    .font(.system(size: 17, weight: .regular))
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                            }
                                            .buttonStyle(.plain)
                                            .padding(.top, 14)
                                        }
                                    }
                                    .padding(.leading, 16)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                    .background {
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(.whiteUniversal)
                                    }
                                }
                                
                                Section {
                                    Button {} label: {
                                        Image("Change")
                                            .frame(width: 36, height: 36)
                                            .background(.whiteUniversal, in: Circle())
                                    }
                                    .buttonStyle(.plain)
                                    .padding(.leading, 16)
                                    .padding(.trailing, 16)
                                }
                            }
                            .padding(.leading, 16)
                            .padding(.top, 16)
                            .padding(.bottom, 16)
                        }
                        .frame(
                            height: 128
                        )
                        .padding(.top, 252)
                        .padding(.leading, 16)
                        .padding(.trailing, 16)
                }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ScheduleView()
}
