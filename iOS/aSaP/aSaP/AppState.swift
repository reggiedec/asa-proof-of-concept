//
//  AppState.swift
//  aSaP
//
//  Created by Dalton Fitzsimmons on 7/1/26.
//

import Foundation
import Observation

@Observable
class AppState {
    var pageList: [String: WidgetList]
    
    var favoriteIDs: Set<UUID>
    
    var favoriteList: WidgetList {
        let favorites = pageList.values.flatMap{ $0.items }.filter { favoriteIDs.contains($0.id) }  // "Flattens" the dictionary to a list only containing favorited items
        
        return .init(items: favorites)
    }
    
    init() {
        // Should change later when using mock data
        // Pages
        pageList = [
            AppVariables.PageKeys.inv : .init(items: [
                ExampleWidget(name: "PLACEHOLDER", isFavorite: false)
            ]),
            AppVariables.PageKeys.fab : .init(items: []),
            AppVariables.PageKeys.ship : .init(items: []),
            AppVariables.PageKeys.fin : .init(items: [
                ExampleWidget(name: "TEST_One", isFavorite: false),
                ExampleWidget(name: "TEST_Two", isFavorite: false),
                ExampleWidget(name: "TEST_Thr", isFavorite: false)
            ]),
        ]
        // Favorites (read to get this)
        favoriteIDs = []
    }
    
    func list(for page: String) -> WidgetList {
        if let existing = pageList[page] {
            return existing
        } else {
            // This should never happen
            let newPage = WidgetList(items: [])
            pageList[page] = newPage
            return newPage
        }
    }
}
