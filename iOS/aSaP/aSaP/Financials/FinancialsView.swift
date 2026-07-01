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
        ReorderableList(widgets: appState.list(for: AppVariables.PageKeys.fin))
    }
}

#Preview {
    @Previewable @State var appState = AppState()
    
    FinancialsView()
        .environment(appState)
}
