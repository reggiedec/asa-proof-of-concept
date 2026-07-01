//
//  InventoryView.swift
//  aSaP
//
//  Created by Dalton Fitzsimmons on 6/29/26.
//

import SwiftUI

struct InventoryView: View {
    @Environment(AppState.self) private var appState
    
    var body: some View {
        ReorderableList(widgets: appState.list(for: AppVariables.PageKeys.inv))
    }
}

#Preview {
    @Previewable @State var appState = AppState()
    
    InventoryView()
        .environment(appState)
}
