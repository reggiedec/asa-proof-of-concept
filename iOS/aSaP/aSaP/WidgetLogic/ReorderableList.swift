//
//  ReorderableList.swift
//  aSaP
//
//  Created by Dalton Fitzsimmons on 6/30/26.
//

import SwiftUI

///  This should be the body of each page we make.
///  Store a WidgetList for each page, to add items to favorited, when favorite button is pushed append to the favorites WidigetList
struct ReorderableList: View {
    @Bindable var widgets: WidgetList
    
    var body: some View {
        List {
            ForEach(widgets.items, id: \.id) { item in
                VStack {
                    WidgetHeader(isFavorite: widgets.getBinding(for: item), widget: item, title: item.name)
                    AnyView(item.body)
                }
            }
            .onMove(perform: widgets.move)
        }
//        .environment(\.editMode, .constant(.active)) // Produces three lines on the side of the item rather than desired 6 dots in top left
    }
}

#Preview {
    @Previewable @State var appState = AppState()
    
    PreviewContainer()
        .environment(appState)
}

struct PreviewContainer: View {
    @State private var widgets = WidgetList(items: [
        ExampleWidget(name: "TEST_One", isFavorite: false),
        ExampleWidget(name: "TEST_Two", isFavorite: false),
        ExampleWidget(name: "TEST_Thr", isFavorite: false),
        ExampleWidget(name: "TEST_Fou", isFavorite: false)
    ])
    
    var body: some View {
        ReorderableList(widgets: widgets)
    }
}
