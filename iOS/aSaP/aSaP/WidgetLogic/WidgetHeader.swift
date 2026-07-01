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
    /// If adjusting sizing, attempt to only alter the variables directly accessible here
    var widget: any WidgetProtocol
    var title: String
    // Margin Padding
    let leftPadding: CGFloat = 0
    let rightPadding: CGFloat = 0
    // Function sizing variables
    let favButtonSize: CGFloat = 28
    let favButtonPadding: CGFloat = 6
    let dragIndicatorCircle: CGFloat = 10
    let dragIndicatorScale: CGFloat = 0.4
    
    /// The favorite button, start surrounded by the circle. Should be bound to the isFavorite bool each WidgetProtocol object has
    /// - Returns: A button View object that is interactable
    private func favoriteButton() -> some View {
        let unfavCircleColor = Color(
            red: 42/255,
            green: 44/255,
            blue: 45/255,
            opacity: 0.06
        )
        let favCircleColor = Color(
            red: 233/255,
            green: 168/255,
            blue: 0/255,
            opacity: 0.15
        )
        // star colors
        let unfavStarColor = Color(
            red: 42/255,
            green: 44/255,
            blue: 45/255,
            opacity: 0.40
        )
        let favStarColor = Color(
            red: 233/255,
            green: 168/255,
            blue: 0/255,
            opacity: 1
        )
        
        return Button {
            if appState.favoriteIDs.contains(widget.id) {
                appState.favoriteIDs.remove(widget.id)
            } else {
                appState.favoriteIDs.insert(widget.id)
            }
        } label: {
            Image(systemName: appState.favoriteIDs.contains(widget.id) ? "star.fill" : "star")
                .resizable()
                .padding(favButtonPadding)
                .foregroundStyle(appState.favoriteIDs.contains(widget.id) ? favStarColor : unfavStarColor)
                .background {
                    Circle()
                        .foregroundStyle(appState.favoriteIDs.contains(widget.id) ? favCircleColor : unfavCircleColor)
                }
                .frame(width: favButtonSize, height: favButtonSize)
        }
        .contentShape(Circle())
//        .frame(width: favButtonSize, height: favButtonSize)
    }
    
    
    /// The six dots on the left hand side of the header. Will need to be addressed later if wanting higher visual quality
    /// - Returns: simple icon for drag indicator
    private func dragIndicator() -> some View {
        let circleColor = Color(
            red: 42/255,
            green: 44/255,
            blue: 45/255,
            opacity: 0.35
        )
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
                .font(.title3)
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
        WidgetHeader(widget: ExampleWidget(name: "TEST_Two", isFavorite: false), title: "Testing even longer title")
    }
    .environment(appState)
}
