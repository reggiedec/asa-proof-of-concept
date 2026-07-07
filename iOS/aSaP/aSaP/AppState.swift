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

    private struct PersistedLayout: Codable {
        var pageOrder: [String: [UUID]]
        var favoriteIDs: [UUID]
    }
    
    private enum Storage {
        static let layoutKey = "app.widgetLayout"
    }
    
    /// Stable IDs for widgets that exist in the app by default.
    ///
    /// Persistence restores layout by matching saved UUIDs to the current widgets. If these values
    /// change, older saved layouts will no longer match the intended widgets, so a user could lose
    /// their saved order or favorite status for those widgets.
    private enum WidgetIDs {
        static let inventoryPlaceholder = UUID(uuid: (
            0x3C, 0x53, 0xD4, 0xAE, 0x30, 0x78, 0x43, 0xD2,
            0xB3, 0x0E, 0x5D, 0xA9, 0x41, 0x7D, 0x5A, 0x70
        ))
        static let financialOverview = UUID(uuid: (
            0x46, 0x5C, 0xD2, 0x43, 0x6E, 0x33, 0x43, 0x82,
            0x8E, 0x11, 0x87, 0x12, 0x05, 0x86, 0xE4, 0xA5
        ))
    }
    
    /// Local store for widget layout preferences.
    @ObservationIgnored private let userDefaults: UserDefaults
    
    var pageList: [String: WidgetList]
    
    var favoriteIDs: Set<UUID> {
        didSet {
            applyFavoriteStatus()
            saveLayout()
        }
    }
    
    var favoriteList: WidgetList {
        // Build Home favorites from current page lists so the displayed widgets are never duplicated.
        let favorites = Self.pageOrder
            .compactMap { pageList[$0] }
            .flatMap { $0.items }
            .filter { favoriteIDs.contains($0.id) }
        
        return .init(items: favorites)
    }
    
    /// Keeps the Home favorites list predictable instead of relying on dictionary ordering.
    private static let pageOrder = [
        AppVariables.PageKeys.inv,
        AppVariables.PageKeys.fab,
        AppVariables.PageKeys.ship,
        AppVariables.PageKeys.fin
    ]
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        
        // Recreate the current widgets first, then layer the user's saved layout onto them.
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
            // Persist newly discovered pages so future launches keep the same page structure.
            saveLayout()
            return newPage
        }
    }
    
    func moveWidgets(on page: String, from source: IndexSet, to destination: Int) {
        guard let list = pageList[page] else { return }
        
        list.move(from: source, to: destination)
        // Save immediately after drag reordering so the next launch restores this order.
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
        // This remains the source of available widgets; persistence only changes their order/favorite state.
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
                FinancialOverviewWidget(id: WidgetIDs.financialOverview)
            ]),
        ]
    }
    
    /// Reorders current widgets using the saved layout without replacing the widgets themselves.
    ///
    /// Saved IDs are only used as ordering hints. IDs that no longer exist are ignored, and current
    /// widgets that were added after the layout was saved are appended to the end of their page.
    /// This avoids overwriting live widget definitions or hiding newly available widgets.
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
            // Append new widgets that were not present when the layout was last saved.
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
        // Store compact IDs instead of widget objects because widget content can be refreshed separately.
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
        // Mirror the saved favorite set back onto each widget for code that reads isFavorite directly.
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
