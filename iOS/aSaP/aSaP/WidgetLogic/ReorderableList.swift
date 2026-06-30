//
//  ReorderableList.swift
//  aSaP
//
//  Created by Dalton Fitzsimmons on 6/30/26.
//

import SwiftUI

///  This should be the body of each page we make.
///  Store a WidgetList for each page, to add items to favorited, when favorite button is pushed append to the favorites WidigetList
struct ReorderableList<Item: WidgetProtocol>: View {
    @Bindable var widgets: WidgetList<Item>
    
    var body: some View {
        List {
            ForEach($widgets.items) { $item in
                VStack {
                    WidgetHeader(isFavorite: $item.isFavorite, title: item.name)
                    item.body
                }
            }
            .onMove(perform: widgets.move)
        }
//        .environment(\.editMode, .constant(.active)) // Produces three lines on the side of the item rather than desired 6 dots in top left
    }
}

#Preview {
    PreviewContainer()
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
