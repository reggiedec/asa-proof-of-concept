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
    @Environment(AppState.self) private var appState
    @Bindable var widgets: WidgetList
    @Binding var runTutorial: Bool
    // When a page key is present, drag changes are saved to AppState for relaunch persistence.
    private let pageKey: String?
    // Variables
    private let widgetCornerRadius: CGFloat = 24
    private let horizontalPadding: CGFloat = 12
    private let verticalPadding: CGFloat = 12
    private let widgetGap: CGFloat = 12 // Does not match Figma, 24 felt way too big
    
    init(widgets: WidgetList, pageKey: String? = nil) {
        self.widgets = widgets
        self.pageKey = pageKey
        self._runTutorial = Binding<Bool>.constant(false)
    }
    
    init(widgets: WidgetList, pageKey: String? = nil, runTutorial: Binding<Bool>) {
        self.widgets = widgets
        self.pageKey = pageKey
        self._runTutorial = runTutorial
    }
    
    private func generateView(item: any WidgetProtocol) -> some View {
        let headerView: WidgetHeader
        
        if runTutorial {
            headerView = WidgetHeader(widget: item, title: item.name, runAnimation: $runTutorial)
        } else {
            headerView = WidgetHeader(widget: item, title: item.name)
        }
        
        return VStack {
            headerView
            AnyView(item.body)
        }
    }
        
        var body: some View {
            List {
                ForEach(widgets.items, id: \.id) { item in
                    generateView(item: item)
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
                .onMove { source, destination in
                    if let pageKey {
                        // Persist real page reorders through AppState so UserDefaults is updated.
                        appState.moveWidgets(on: pageKey, from: source, to: destination)
                    } else {
                        // Derived or preview lists can still move locally without writing layout data.
                        widgets.move(from: source, to: destination)
                    }
                }
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
