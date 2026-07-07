//
//  FinancialsView.swift
//  aSaP
//
//  Created by Dalton Fitzsimmons on 6/29/26.
//

import SwiftUI

struct FinancialsView: View {
    @Environment(AppState.self) private var appState
    
    var body: some View {
        // Passing the page key lets ReorderableList save this page's widget order.
        ReorderableList(
            widgets: appState.list(for: AppVariables.PageKeys.fin),
            pageKey: AppVariables.PageKeys.fin
        )
    }
}

#Preview {
    @Previewable @State var appState = AppState()
    
    FinancialsView()
        .environment(appState)
}
