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
class WidgetList<Item: WidgetProtocol> {
    // Append items/remove items when adding to favorites or create a page
    var items: [Item]
    
    init(items: [Item]) {
        self.items = items
    }
    
    func move(from source: IndexSet, to destination: Int) {
        items.move(fromOffsets: source, toOffset: destination)
    }
}
