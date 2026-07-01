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
    // Variables
    private let widgetCornerRadius: CGFloat = 24
    private let horizontalPadding: CGFloat = 12
    private let verticalPadding: CGFloat = 12
    private let widgetGap: CGFloat = 12 // Does not match Figma, 24 felt way too big
    
    var body: some View {
        List {
            ForEach(widgets.items, id: \.id) { item in
                VStack {
                    WidgetHeader(widget: item, title: item.name)
                    AnyView(item.body)
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
                .frame(maxWidth: .infinity)
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical, verticalPadding)
                .background(
                    RoundedRectangle(cornerRadius: widgetCornerRadius)
                        .fill(.white)
                )
                .padding(.vertical, widgetGap)
            }
            .onMove(perform: widgets.move)
        }
        .scrollContentBackground(.hidden)
        .buttonStyle(.borderless)
        .background(Color("BackgroundColor")) // Changes the color for each page
        
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
