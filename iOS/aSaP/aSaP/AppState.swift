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
        // TODO: Check that this works as intended (When debugging shows mock data, when "live" show real)
        #if DEBUG
            pageList = [
                AppVariables.PageKeys.inv : .init(items: [
                    StockLevelsWidget()
                ]),
                AppVariables.PageKeys.fab : .init(items: [
                    FabDetailsWidget(jobDetails: [
                        JobDetail(name: "J-2245", status: .atRisk,
                            dueDate: "Jun 12", location: "Middletown Parking Garage", company: "Valley Structures", amountCompleted: 34.2, amountTotal: 84.2, ordersCompleted: 9, ordersTotal: 22
                        ),
                        JobDetail(name: "J-2233", status: .onTrack, dueDate: "Jun 12", location: "Small", company: "Really long smaller text to see contrast", amountCompleted: 30.0, amountTotal: 60.0, ordersCompleted: 15, ordersTotal: 30
                        ),
                        JobDetail(name: "J-2241", status: .scheduled, dueDate: "Jun 19", location: "Really long main text to check length amount", company: "Checking how overflow looks on the smaller bottom bar", amountCompleted: 0.0, amountTotal: 40.0, ordersCompleted: 0, ordersTotal: 10
                        ),
                        JobDetail(name: "J-2251", status: .completed, dueDate: "Jun 07", location: "Longer Main Text but not too long", company: "small", amountCompleted: 100.0, amountTotal: 100.0, ordersCompleted: 25, ordersTotal: 25
                        )
                    ])
                ]),
                AppVariables.PageKeys.ship : .init(items: []),
                AppVariables.PageKeys.fin : .init(items: [
                    ExampleWidget(name: "TEST_One", isFavorite: false),
                    ExampleWidget(name: "TEST_Two", isFavorite: false),
                    ExampleWidget(name: "TEST_Thr", isFavorite: false)
                ]),
            ]
        #else
            pageList = [
                AppVariables.PageKeys.inv : .init(items: []),
                AppVariables.PageKeys.fab : .init(items: []),
                AppVariables.PageKeys.ship : .init(items: []),
                AppVariables.PageKeys.fin : .init(items: []),
            ]
        #endif
        
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
