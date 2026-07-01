//
//  WidgetList.swift
//  aSaP
//
//  Created by Dalton Fitzsimmons on 6/30/26.
//

import SwiftUI
import Observation

/// List object for each page that should allow for a dynamic favorites list
@Observable
class WidgetList {
    // Append items/remove items when adding to favorites or create a page
    var items: [any WidgetProtocol]
    
    init(items: [any WidgetProtocol]) {
        self.items = items
    }
    
    func move(from source: IndexSet, to destination: Int) {
        items.move(fromOffsets: source, toOffset: destination)
    }
    
    func getBinding(for item: any WidgetProtocol) -> Binding<Bool> {
        if let index = items.firstIndex(where: { $0.id == item.id }) { // should be safe overall outside of edge cases
            return Binding(
                get: { self.items[index].isFavorite },
                set: { self.items[index].isFavorite = $0 }
            )
        } else {
            // no binding found or (maybe) 1+ isntances of item
            return .constant(false)
        }
    }
}
