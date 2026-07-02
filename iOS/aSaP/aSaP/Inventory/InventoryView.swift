//
//  InventoryView.swift
//  aSaP
//
//  Created by Dalton Fitzsimmons on 6/29/26.
//

import SwiftUI

struct InventoryView: View {
    @Environment(AppState.self) private var appState
    
    @Binding var favoriteGuide: Bool
    
    var body: some View {
        // Passing the page key lets ReorderableList save this page's widget order.
        ReorderableList(
            widgets: appState.list(for: AppVariables.PageKeys.inv),
            pageKey: AppVariables.PageKeys.inv,
            runTutorial: $favoriteGuide
        )
    }
        
}

#Preview {
    @Previewable @State var appState = AppState()
    
    InventoryView(favoriteGuide: Binding<Bool>.constant(true))
        .environment(appState)
}
