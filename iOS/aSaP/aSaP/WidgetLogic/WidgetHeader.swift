//
//  WidgetHeader.swift
//  aSaP
//
//  Created by Dalton Fitzsimmons on 6/30/26.
//

import SwiftUI

/// Header for the different widgets.
/// Should only be called in ReorderableList
struct WidgetHeader: View {
    @Environment(AppState.self) private var appState
    @Binding private var runAnimation: Bool
    @State private var glow: Bool = false
    /// If adjusting sizing, attempt to only alter the variables directly accessible here
    var widget: any WidgetProtocol
    var title: String
    // Margin Padding
    private let leftPadding: CGFloat = 0
    private let rightPadding: CGFloat = 0
    // Function sizing variables
    private let favButtonSize: CGFloat = 28
    private let favButtonPadding: CGFloat = 6
    private let dragIndicatorCircle: CGFloat = 10
    private let dragIndicatorScale: CGFloat = 0.4
    // Colors
    private let unfavCircleColor = Color(
        red: 42/255,
        green: 44/255,
        blue: 45/255,
        opacity: 0.06
    )
    private let favCircleColor = Color(
        red: 233/255,
        green: 168/255,
        blue: 0/255,
        opacity: 0.15
    )
    // star colors
    private let unfavStarColor = Color(
        red: 42/255,
        green: 44/255,
        blue: 45/255,
        opacity: 0.40
    )
    private let favStarColor = Color(
        red: 233/255,
        green: 168/255,
        blue: 0/255,
        opacity: 1
    )
    // Drag colors
    private let circleColor = Color(
        red: 42/255,
        green: 44/255,
        blue: 45/255,
        opacity: 0.35
    )
    
    init(widget: any WidgetProtocol, title: String) {
        self.widget = widget
        self.title = title
        self._runAnimation = .constant(false)
    }
    
    init(widget: any WidgetProtocol, title: String, runAnimation: Binding<Bool>) {
        self.widget = widget
        self.title = title
        self._runAnimation = runAnimation
    }
    
    private func playAnimation() {
        Task {
            for _ in 0..<3 {
                withAnimation(.easeInOut(duration: 1.0)) {
                    glow = true
                }
                try? await Task.sleep(for: .seconds(1.0))
                withAnimation(.easeInOut(duration: 1.0)) {
                    glow = false
                }
                try? await Task.sleep(for: .seconds(1.0))
            }
        }
        runAnimation = false
    }
    
    /// The favorite button, start surrounded by the circle. Should be bound to the isFavorite bool each WidgetProtocol object has
    /// - Returns: A button View object that is interactable
    private func favoriteButton() -> some View {
        let isFavorited = appState.favoriteIDs.contains(widget.id)
        
        return Button {
            if isFavorited {
                appState.favoriteIDs.remove(widget.id)
            } else {
                appState.favoriteIDs.insert(widget.id)
            }
        } label: {
            Image(systemName: isFavorited ? "star.fill" : "star")
                .resizable()
                .padding(favButtonPadding)
                .foregroundStyle(isFavorited || glow ? favStarColor : unfavStarColor)
                .background {
                    Circle()
                        .fill(isFavorited || glow ? favCircleColor : unfavCircleColor)
                        .onAppear {
                            guard runAnimation else { return }
                            playAnimation()
                        }
                        .onChange(of: runAnimation) { _, newValue in
                            guard newValue else { return }
                            playAnimation()
                        }
                }
                .frame(width: favButtonSize, height: favButtonSize)
                
        }
        .contentShape(Circle())
        .animation(
            runAnimation
                ? .easeInOut(duration: 1).repeatForever(autoreverses: true)
                : .easeInOut(duration: 0.3),   // smooth exit animation when unfavorited
            value: runAnimation
        )
    }
    
    
    /// The six dots on the left hand side of the header. Will need to be addressed later if wanting higher visual quality
    /// - Returns: simple icon for drag indicator
    private func dragIndicator() -> some View {
        let dotImage = Image(systemName: "circle.fill")
            .resizable()
            .frame(width: dragIndicatorCircle, height: dragIndicatorCircle)
            .foregroundStyle(circleColor)
        
        return VStack {
            HStack {
                dotImage
                dotImage
            }
            HStack {
                dotImage
                dotImage
            }
            HStack {
                dotImage
                dotImage
            }
        }
        .scaleEffect(dragIndicatorScale)
    }
    
    var body: some View {
        HStack {
            dragIndicator()
                .padding(.leading, leftPadding)
            Text(title)
                .font(Font.custom("BeVietnamPro-Regular", size: 18))
                .bold()
            
            Spacer()
            favoriteButton()
                .padding(.trailing, rightPadding)
        }
    }
}

#Preview {
    @Previewable @State var appState = AppState()
    
    VStack {
        WidgetHeader(widget: ExampleWidget(name: "TEST_One", isFavorite: false), title: "Testing Title")
        WidgetHeader(widget: ExampleWidget(name: "TEST_Two", isFavorite: false), title: "Testing an even longer title")
    }
    .environment(appState)
}
