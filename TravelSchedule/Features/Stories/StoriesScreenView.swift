//
//  StoriesScreenView.swift
//  TravelSchedule
//
//  Created by Anastasia Belyakova on 18.08.2026.
//

import SwiftUI

struct StoriesScreenView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(StoriesViewedStore.self) private var viewedStore
    
    let stories: [Story]
    let initialIndex: Int
    
    @State private var currentIndex: Int
    @State private var progress: Double = 0
    @State private var verticalDragOffset: CGFloat = 0
    
    private let storyDuration: TimeInterval = 10
    private let dismissDragThreshold: CGFloat = 120
    
    init(stories: [Story] = StoriesContent.stories, initialIndex: Int = 0) {
        self.stories = stories
        self.initialIndex = initialIndex
        _currentIndex = State(initialValue: initialIndex)
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
                        .offset(y: verticalDragOffset)
                        .opacity(dismissOpacity)
                    
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
                        
                        Text(stories[currentIndex].title)
                            .foregroundStyle(.whiteUniversal)
                            .font(.system(size: 34, weight: .bold))
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 16)
                        
                        Text(stories[currentIndex].description)
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
            markCurrentStoryAsViewed()
        }
        .onChange(of: currentIndex) { _, _ in
            markCurrentStoryAsViewed()
        }
        .task(id: currentIndex) {
            await runStoryTimer()
        }
    }
    
    private func storyImage(size: CGSize) -> some View {
        Image(stories[currentIndex].imageName)
            .resizable()
            .scaledToFill()
            .frame(width: size.width, height: size.height)
            .clipped()
    }
    
    private var closeButton: some View {
        Button {
            dismiss()
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
            ForEach(stories.indices, id: \.self) { index in
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(.whiteUniversal)
                        
                        Capsule()
                            .fill(.blueUniversal)
                            .frame(width: progressWidth(for: index, totalWidth: geometry.size.width))
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
                    goToPreviousStory()
                }
            
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    goToNextStory()
                }
        }
    }
    
    private var navigationGesture: some Gesture {
        DragGesture(minimumDistance: 20)
            .onChanged { value in
                guard abs(value.translation.height) > abs(value.translation.width) else { return }
                verticalDragOffset = max(0, value.translation.height)
            }
            .onEnded { value in
                let horizontalMovement = value.translation.width
                let verticalMovement = value.translation.height
                
                if verticalMovement > dismissDragThreshold,
                   abs(verticalMovement) > abs(horizontalMovement) {
                    dismiss()
                    return
                }
                
                if horizontalMovement < -50 {
                    goToNextStory()
                } else if horizontalMovement > 50 {
                    goToPreviousStory()
                }
                
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    verticalDragOffset = 0
                }
            }
    }
    
    private var dismissOpacity: Double {
        let progress = min(max(verticalDragOffset / 300, 0), 1)
        return 1 - progress * 0.4
    }
    
    private func progressWidth(for index: Int, totalWidth: CGFloat) -> CGFloat {
        if index < currentIndex {
            return totalWidth
        }
        
        if index > currentIndex {
            return 0
        }
        
        return totalWidth * progress
    }
    
    private func runStoryTimer() async {
        progress = 0
        let startDate = Date()
        
        while !Task.isCancelled {
            let elapsed = Date().timeIntervalSince(startDate)
            progress = min(elapsed / storyDuration, 1)
            
            if elapsed >= storyDuration {
                goToNextStory()
                return
            }
            
            try? await Task.sleep(for: .milliseconds(50))
        }
    }
    
    private func goToNextStory() {
        if currentIndex < stories.count - 1 {
            currentIndex += 1
        } else {
            dismiss()
        }
    }
    
    private func goToPreviousStory() {
        guard currentIndex > 0 else { return }
        currentIndex -= 1
    }
    
    private func markCurrentStoryAsViewed() {
        viewedStore.markAsViewed(stories[currentIndex].id)
    }
}

#Preview {
    StoriesScreenView()
        .environment(StoriesViewedStore())
}
