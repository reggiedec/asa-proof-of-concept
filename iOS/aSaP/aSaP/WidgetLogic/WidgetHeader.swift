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
    @Binding var isFavorite: Bool
    var widget: any WidgetProtocol
    var title: String
    // Margin Padding
    let horizontalPadding: CGFloat = 0
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
            // TODO: Check if this is working
            isFavorite.toggle()
            // need to unfavorite both in the favorites tab and in individual one
        } label: {
            Image(systemName: isFavorite ? "star.fill" : "star")
                .resizable()
                .padding(favButtonPadding)
                .foregroundStyle(isFavorite ? favStarColor : unfavStarColor)
                .overlay {
                    Circle()
                        .foregroundStyle(isFavorite ? favCircleColor : unfavCircleColor)
                }
                .frame(width: favButtonSize, height: favButtonSize)
        }
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
                .padding(.leading, horizontalPadding)
            Text(title)
                .font(.title3)
                .bold()
            
            Spacer()
            favoriteButton()
                .padding(.trailing, horizontalPadding)
        }
    }
}

#Preview {
    @Previewable @State var favorited: Bool = true
    @Previewable @State var unfav: Bool = false
    @Previewable @State var appState = AppState()
    
    VStack {
        WidgetHeader(isFavorite: $favorited, widget: ExampleWidget(name: "TEST_One", isFavorite: false), title: "Testing Title")
        WidgetHeader(isFavorite: $unfav, widget: ExampleWidget(name: "TEST_Two", isFavorite: false), title: "Testing even longer title")
    }
    .environment(appState)
}
