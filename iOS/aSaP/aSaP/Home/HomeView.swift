//
//  HomeView.swift
//  aSaP
//
//  Created by Dalton Fitzsimmons on 6/29/26.
//

import SwiftUI

struct HomeView: View {
    @Environment(AppState.self) private var appState
    @Binding var selectedTab: Int
    @Binding var favoriteGuide: Bool
    
    var body: some View {
        ReorderableList(widgets: appState.favoriteList)
            .overlay {
                if appState.favoriteIDs.isEmpty {
                    FavoriteGuideWidget(selectedTab: $selectedTab, favoriteGuide: $favoriteGuide)
                }
            }
    }
}

#Preview {
    @Previewable @State var appState = AppState()
    
    HomeView(selectedTab: Binding<Int>.constant(0), favoriteGuide: Binding<Bool>.constant(false))
        .environment(appState)
}
