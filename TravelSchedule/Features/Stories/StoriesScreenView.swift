//
//  StoriesScreenView.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 18.08.2026.
//

import SwiftUI

struct StoriesScreenView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: StoriesScreenViewModel
    
    init(
        stories: [Story] = StoriesContent.stories,
        initialIndex: Int = 0,
        viewedStore: StoriesViewedStore
    ) {
        _viewModel = State(
            initialValue: StoriesScreenViewModel(
                stories: stories,
                initialIndex: initialIndex,
                viewedStore: viewedStore
            )
        )
    }
    
    var body: some View {
        ZStack {
            Color.blackUniversal
                .ignoresSafeArea()
            
            GeometryReader { geometry in
                let storySize = CGSize(
                    width: geometry.size.width,
                    height: max(0, geometry.size.height - 7)
                )
                
                ZStack(alignment: .top) {
                    storyImage(size: storySize)
                        .offset(y: viewModel.verticalDragOffset)
                        .opacity(viewModel.dismissOpacity)
                    
                    navigationOverlay
                    
                    VStack(alignment: .leading, spacing: 8) {
                        progressIndicators
                            .padding(.horizontal, 12)
                            .padding(.top, 28)
                        
                        HStack {
                            Spacer()
                            
                            closeButton
                                .padding(.trailing, 12)
                                .padding(.top, 16)
                        }
                        
                        Spacer()
                        
                        Text(viewModel.currentStory.title)
                            .foregroundStyle(.whiteUniversal)
                            .font(.system(size: 34, weight: .bold))
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 16)
                        
                        Text(viewModel.currentStory.description)
                            .foregroundStyle(.whiteUniversal)
                            .font(.system(size: 20, weight: .regular))
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 16)
                            .padding(.bottom, 40)
                    }
                }
                .frame(width: storySize.width, height: storySize.height)
                .clipShape(RoundedRectangle(cornerRadius: 40))
                .padding(.top, 7)
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .top)
            }
        }
        .gesture(navigationGesture)
        .onAppear {
            viewModel.markCurrentStoryAsViewed()
        }
        .onChange(of: viewModel.currentIndex) { _, _ in
            viewModel.markCurrentStoryAsViewed()
        }
        .onChange(of: viewModel.shouldDismiss) { _, shouldDismiss in
            guard shouldDismiss else { return }
            dismiss()
        }
        .task(id: viewModel.currentIndex) {
            await viewModel.runStoryTimer()
        }
    }
    
    private func storyImage(size: CGSize) -> some View {
        Image(viewModel.currentStory.imageName)
            .resizable()
            .scaledToFill()
            .frame(width: size.width, height: size.height)
            .clipped()
    }
    
    private var closeButton: some View {
        Button {
            viewModel.requestDismiss()
        } label: {
            Image(systemName: "xmark")
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(.whiteUniversal)
                .frame(width: 24, height: 24)
                .background(.blackUniversal, in: Circle())
        }
        .buttonStyle(.plain)
    }
    
    private var progressIndicators: some View {
        HStack(spacing: 4) {
            ForEach(viewModel.stories.indices, id: \.self) { index in
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(.whiteUniversal)
                        
                        Capsule()
                            .fill(.blueUniversal)
                            .frame(
                                width: viewModel.progressWidth(
                                    for: index,
                                    totalWidth: geometry.size.width
                                )
                            )
                    }
                }
                .frame(height: 6)
            }
        }
        .frame(height: 6)
    }
    
    private var navigationOverlay: some View {
        HStack(spacing: 0) {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.goToPreviousStory()
                }
            
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.goToNextStory()
                }
        }
    }
    
    private var navigationGesture: some Gesture {
        DragGesture(minimumDistance: 20)
            .onChanged { value in
                viewModel.handleDragChanged(translation: value.translation)
            }
            .onEnded { value in
                switch viewModel.handleDragEnded(translation: value.translation) {
                case .dismissScreen:
                    dismiss()
                case .resetOffset:
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        viewModel.resetDragOffset()
                    }
                }
            }
    }
}

#Preview {
    StoriesScreenView(viewedStore: StoriesViewedStore())
}
