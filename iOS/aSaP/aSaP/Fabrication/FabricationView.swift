//
//  FabricationView.swift
//  aSaP
//
//  Created by Dalton Fitzsimmons on 6/29/26.
//

import SwiftUI

struct FabricationView: View {
    @Environment(AppState.self) private var appState
    
    var body: some View {
        ReorderableList(widgets: appState.list(for: AppVariables.PageKeys.fab))
    }
}

#Preview {
    @Previewable @State var appState = AppState()
    
    FabricationView()
        .environment(appState)
}
