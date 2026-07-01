//
//  HomeView.swift
//  aSaP
//
//  Created by Dalton Fitzsimmons on 6/29/26.
//

import SwiftUI

struct HomeView: View {
    @Environment(AppState.self) private var appState
    
    var body: some View {
        ReorderableList(widgets: appState.favoriteList)
    }
}

#Preview {
    @Previewable @State var appState = AppState()
    
    HomeView()
        .environment(appState)
}
