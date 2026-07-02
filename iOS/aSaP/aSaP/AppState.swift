//
//  AppState.swift
//  aSaP
//
//  Created by Dalton Fitzsimmons on 7/1/26. + Reg :P 7/2/26
//

import Foundation
import Observation

@Observable
class AppState {
    // Stores only user layout choices, not live widget data, so widgets can refresh normally on launch. -reg
    private struct PersistedLayout: Codable {
        var pageOrder: [String: [UUID]]
        var favoriteIDs: [UUID]
    }
    
    private enum Storage {
        static let layoutKey = "app.widgetLayout"
    }
    
    // These IDs must stay stable because saved order and favorites are restored by widget ID. -reg
    private enum WidgetIDs {
        static let inventoryPlaceholder = UUID(uuid: (
            0x3C, 0x53, 0xD4, 0xAE, 0x30, 0x78, 0x43, 0xD2,
            0xB3, 0x0E, 0x5D, 0xA9, 0x41, 0x7D, 0x5A, 0x70
        ))
        static let financialTestOne = UUID(uuid: (
            0x46, 0x5C, 0xD2, 0x43, 0x6E, 0x33, 0x43, 0x82,
            0x8E, 0x11, 0x87, 0x12, 0x05, 0x86, 0xE4, 0xA5
        ))
        static let financialTestTwo = UUID(uuid: (
            0xA4, 0x82, 0xD2, 0x8C, 0x2F, 0xE1, 0x4D, 0x2F,
            0xB6, 0x02, 0x3D, 0xA8, 0xC9, 0x71, 0x49, 0x35
        ))
        static let financialTestThree = UUID(uuid: (
            0x87, 0x24, 0xDC, 0xE9, 0x4E, 0x53, 0x46, 0x1E,
            0xAE, 0xFD, 0x4D, 0x48, 0xF4, 0x23, 0x0E, 0x3D
        ))
    }
    
    // UserDefaults is injected so previews or tests can use a separate store if needed. -reg
    @ObservationIgnored private let userDefaults: UserDefaults
    
    var pageList: [String: WidgetList]
    
    var favoriteIDs: Set<UUID> {
        didSet {
            applyFavoriteStatus()
            saveLayout()
        }
    }
    
    var favoriteList: WidgetList {
        // Build Home favorites from current page lists so the displayed widgets are never duplicated. -reg
        let favorites = Self.pageOrder
            .compactMap { pageList[$0] }
            .flatMap { $0.items }
            .filter { favoriteIDs.contains($0.id) }
        
        return .init(items: favorites)
    }
    
    // Keeps the Home favorites list predictable instead of relying on dictionary ordering. -reg
    private static let pageOrder = [
        AppVariables.PageKeys.inv,
        AppVariables.PageKeys.fab,
        AppVariables.PageKeys.ship,
        AppVariables.PageKeys.fin
    ]
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        
        // Recreate the current widgets first, then layer the user's saved layout onto them. -reg
        let savedLayout = Self.loadLayout(from: userDefaults)
        favoriteIDs = Set(savedLayout?.favoriteIDs ?? [])
        pageList = Self.applySavedOrder(
            to: Self.defaultPageList(),
            savedPageOrder: savedLayout?.pageOrder ?? [:]
        )
        applyFavoriteStatus()
    }
    
    func list(for page: String) -> WidgetList {
        if let existing = pageList[page] {
            return existing
        } else {
            let newPage = WidgetList(items: [])
            pageList[page] = newPage
            // Persist newly discovered pages so future launches keep the same page structure. -reg
            saveLayout()
            return newPage
        }
    }
    
    func moveWidgets(on page: String, from source: IndexSet, to destination: Int) {
        guard let list = pageList[page] else { return }
        
        list.move(from: source, to: destination)
        // Save immediately after drag reordering so the next launch restores this order. -reg
        saveLayout()
    }
    
    func toggleFavorite(for widgetID: UUID) {
        if favoriteIDs.contains(widgetID) {
            favoriteIDs.remove(widgetID)
        } else {
            favoriteIDs.insert(widgetID)
        }
    }
    
    private static func defaultPageList() -> [String: WidgetList] {
        // This remains the source of available widgets; persistence only changes their order/favorite state. -reg
        [
            AppVariables.PageKeys.inv : .init(items: [
                ExampleWidget(
                    id: WidgetIDs.inventoryPlaceholder,
                    name: "PLACEHOLDER",
                    isFavorite: false
                )
            ]),
            AppVariables.PageKeys.fab : .init(items: []),
            AppVariables.PageKeys.ship : .init(items: []),
            AppVariables.PageKeys.fin : .init(items: [
                ExampleWidget(
                    id: WidgetIDs.financialTestOne,
                    name: "TEST_One",
                    isFavorite: false
                ),
                ExampleWidget(
                    id: WidgetIDs.financialTestTwo,
                    name: "TEST_Two",
                    isFavorite: false
                ),
                ExampleWidget(
                    id: WidgetIDs.financialTestThree,
                    name: "TEST_Thr",
                    isFavorite: false
                )
            ]),
        ]
    }
    
    private static func applySavedOrder(
        to defaultPages: [String: WidgetList],
        savedPageOrder: [String: [UUID]]
    ) -> [String: WidgetList] {
        var orderedPages: [String: WidgetList] = [:]
        
        for (page, widgetList) in defaultPages {
            guard let savedIDs = savedPageOrder[page] else {
                orderedPages[page] = widgetList
                continue
            }
            
            let widgetsByID = Dictionary(uniqueKeysWithValues: widgetList.items.map { ($0.id, $0) })
            var orderedWidgets = savedIDs.compactMap { widgetsByID[$0] }
            let orderedIDs = Set(orderedWidgets.map(\.id))
            // Append new widgets that were not present when the layout was last saved. -reg
            let newWidgets = widgetList.items.filter { !orderedIDs.contains($0.id) }
            
            orderedWidgets.append(contentsOf: newWidgets)
            orderedPages[page] = WidgetList(items: orderedWidgets)
        }
        
        return orderedPages
    }
    
    private static func loadLayout(from userDefaults: UserDefaults) -> PersistedLayout? {
        guard let data = userDefaults.data(forKey: Storage.layoutKey) else { return nil }
        
        return try? JSONDecoder().decode(PersistedLayout.self, from: data)
    }
    
    private func saveLayout() {
        // Store compact IDs instead of widget objects because widget content can be refreshed separately. -reg
        let pageOrder = pageList.mapValues { widgetList in
            widgetList.items.map(\.id)
        }
        let layout = PersistedLayout(
            pageOrder: pageOrder,
            favoriteIDs: Array(favoriteIDs)
        )
        
        guard let data = try? JSONEncoder().encode(layout) else { return }
        userDefaults.set(data, forKey: Storage.layoutKey)
    }
    
    private func applyFavoriteStatus() {
        // Mirror the saved favorite set back onto each widget for code that reads isFavorite directly. -reg
        for page in pageList.keys {
            guard let items = pageList[page]?.items else { continue }
            
            pageList[page]?.items = items.map { item in
                var updatedItem = item
                updatedItem.isFavorite = favoriteIDs.contains(item.id)
                return updatedItem
            }
        }
    }
}
