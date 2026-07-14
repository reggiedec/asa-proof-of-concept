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
        /*
         Optional Id section
         run "uuidgen" in terminal to get a UUID, past when adding new value to the application
         Example result
         28FA5593-A92F-470A-993B-909801F28EAA
         Then
         static let exampleID = UUID(uuidString: "28FA5593-A92F-470A-993B-909801F28EAA")!
         */
        static let inventoryOverview = UUID(uuidString: "713A5542-E15D-4B26-AEC7-5D63911D9D9F")!
        static let stockLevelsWidget = UUID(uuidString: "3A029128-E557-470E-955C-9FD5CBAD4A9A")!
        static let fabricationOverview = UUID(uuidString: "936D06BD-BA4B-4C30-82F7-37D5983A05C1")!
        static let fabDetailsWidget = UUID(uuidString: "1D62AF8C-4534-437B-9AE2-2A51C3618A2A")!
        static let shippingOverview = UUID(uuidString: "28FA5593-A92F-470A-993B-909801F28EAA")!
        static let financialOverview = UUID(uuidString: "465CD243-6E33-4382-8E11-87120586E4A5")!
        // ExampleWidgets
        static let financialTestOne = UUID(uuidString: "558CA072-4DDB-4967-93B4-856D15DB190E")!
        static let financialTestTwo = UUID(uuidString: "FA51C8C4-AD08-4F63-BC37-F2768108312A")!
        static let financialTestThr = UUID(uuidString: "543721F1-578D-4B83-A5E6-B7C21FDC2CAF")!
        static let estimatesWidget = UUID(uuidString: "B94BBD2D-D458-49AE-8E96-D8A1B76E7A58")!
        static let financialDetailsWidget = UUID(uuidString: "33744243-1D55-46CC-AC7A-30F6A33F4AA9")!
        static let loadOrderStatusWidget = UUID(uuidString: "CC1F5870-9BD7-414E-9A45-024A39EE2271")!
        
    }
    /// Local store for widget layout preferences.
    @ObservationIgnored private let userDefaults: UserDefaults
    
    /// Stores selected locations, as strings so when the location selector sheet is dismissed it can refetch data for only those desired locations
    /// Is a string rather than UUID so that the API can use the values directly from here (hopefully) 
    var selectedLocationIDs: Set<String> = []
    var locations: [FabLocation] = fetchFabLocations() // probably not the best thing to do 
    
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
        var pageList: [String: WidgetList] = [:]
        
        #if DEBUG
            pageList = [
                AppVariables.PageKeys.inv : .init(items: [
                    OverviewWidget(
                        id: WidgetIDs.inventoryOverview,
                        name: "Inventory Overview",
                        metrics: inventoryOverviewMetrics()
                    ),
                    StockLevelsWidget(id: WidgetIDs.stockLevelsWidget, stockItems: [
                        StockItem(name: "RB0360", description: "Rebar Black #3 Grade 60", quantity: 80.0, minimum: 100.0),
                        StockItem(name: "#5 Rebar (5/8\")", description: "Rebar Black #3 Grade 60", quantity: 120.0, minimum: 100.0),
                        StockItem(name: "#4 Rebar (1/2\")", description: "Rebar Black #3 Grade 60", quantity: 230.0, minimum: 100.0),
                    ])
                ]),
                AppVariables.PageKeys.fab : .init(items: [
                    OverviewWidget(
                        id: WidgetIDs.fabricationOverview,
                        name: "Fabrication Overview",
                        metrics: fabricationOverviewMetrics()
                    ),
                    FabDetailsWidget(id: WidgetIDs.fabDetailsWidget, jobDetails: [
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
                AppVariables.PageKeys.ship : .init(items: [
                    OverviewWidget(
                        id: WidgetIDs.shippingOverview,
                        name: "Shipping Overview",
                        metrics: shippingOverviewMetrics()
                    ),
                    LoadOrderStatusWidget(id: WidgetIDs.loadOrderStatusWidget, statuses: [
                        LOSDetails(title: "Load 1", location: "Warehouse A", weight: 1200, shipments: 5, orders: 10, date: "6/29/26", status: .delayed),
                        LOSDetails(title: "Load 2", location: "Warehouse B", weight: 800, shipments: 3, orders: 7, date: "6/39/26", status: .pending),
                        LOSDetails(title: "Load 3", location: "Warehouse C", weight: 1500, shipments: 6, orders: 12, date: "ETA 12:55 pm", status: .loading),
                        LOSDetails(title: "Load 4", location: "Warehouse D", weight: 1000, shipments: 4, orders: 8, date: "ETA 1:35 pm", status: .transit),
                        LOSDetails(title: "Load 5", location: "Warehouse E", weight: 900, shipments: 2, orders: 5, date: "5/20/26", status: .delivered)
                    ])
                ]),
                AppVariables.PageKeys.fin : .init(items: [
                    FinancialSummaryWidget(id: WidgetIDs.financialDetailsWidget, information: [
                        .init(title: "Gross Margin", subtitle: "+2.1pts vs last month", pillInformation: .init(textInformation: "40%", pillState: .positive, colorScheme: .positive), types: [.againg, .ratios]),
                        .init(title: "Net Revenue", subtitle: "-1.3% vs last quarter", pillInformation: .init(textInformation: "$120K", pillState: .negative, colorScheme: .negative), types: [.p_l, .againg]),
                        .init(title: "Debt Ratio", subtitle: "Stable", pillInformation: .init(textInformation: "1.2", pillState: .neutral, colorScheme: .neutral), types: [.ratios, .p_l]),
                        .init(title: "Operating Income", subtitle: "+5% YTD", pillInformation: .init(textInformation: "$50K", pillState: .positive, colorScheme: .positive), types: [.againg, .ratios])
                    ]),
                    OverviewWidget(
                        id: WidgetIDs.financialOverview,
                        name: "Financial Overview",
                        metrics: financialOverviewMetrics()
                    ),
                    ExampleWidget(id: WidgetIDs.financialTestOne, name: "TEST_One", isFavorite: false),
                    EstimatesWidget(id: WidgetIDs.estimatesWidget, estimates: [
                        .init(estimateName: "Estimate Name", companyName: "Company Name", date: "Date", weight: 1_000_000, value: 1_000_000, estimateStatus: .won),
                        .init(estimateName: "Estimate Name", companyName: "Company Name", date: "Date", weight: 1_000_000, value: 1_000_000, estimateStatus: .submitted),
                        .init(estimateName: "Estimate Name", companyName: "Company Name", date: "Date", weight: 1_000_000, value: 1_000_000, estimateStatus: .open),
                        .init(estimateName: "Estimate Name", companyName: "Company Name", date: "Date", weight: 1_000_000, value: 1_000_000, estimateStatus: .lost),
                    ])
                ]),
            ]
        #else
        // Should be getting/building/refreshing widgets with API info when in prod
            pageList = [
                AppVariables.PageKeys.inv : .init(items: []),
                AppVariables.PageKeys.fab : .init(items: []),
                AppVariables.PageKeys.ship : .init(items: []),
                AppVariables.PageKeys.fin : .init(items: []),
            ]
        #endif
        
        return pageList
    }

    private static func inventoryOverviewMetrics() -> [OverviewMetric] {
        [
            OverviewMetric(id: "sku-count", title: "# of SKUs", value: "10"),
            OverviewMetric(id: "in-stock", title: "In Stock", value: "6"),
            OverviewMetric(id: "inventory-alerts", title: "Alerts", value: "4", status: .critical, actionTitle: "View")
        ]
    }

    private static func fabricationOverviewMetrics() -> [OverviewMetric] {
        [
            OverviewMetric(id: "active-jobs", title: "Active Jobs", value: "5"),
            OverviewMetric(id: "machine-issues", title: "Machine Issues", value: "1", status: .critical, actionTitle: "View")
        ]
    }

    private static func shippingOverviewMetrics() -> [OverviewMetric] {
        [
            OverviewMetric(id: "active-loads", title: "Active Loads", value: "43"),
            OverviewMetric(id: "tonnage", title: "Tonnage", value: "1.8k"),
            OverviewMetric(id: "in-transit", title: "In Transit", value: "8"),
            OverviewMetric(id: "shipping-exceptions", title: "Shipping Exceptions", value: "3", status: .critical, actionTitle: "View")
        ]
    }

    private static func financialOverviewMetrics() -> [OverviewMetric] {
        [
            OverviewMetric(id: "cash-on-hand", title: "Cash on Hand", value: "$387k"),
            OverviewMetric(id: "accounts-payable", title: "Accounts Payable", value: "$125k", status: .critical, actionTitle: "View"),
            OverviewMetric(id: "total-weekly-sales", title: "Total Weekly Sales", value: "$352k"),
            OverviewMetric(id: "accounts-receivable", title: "Accounts Receivable", value: "$113k", status: .critical, actionTitle: "View")
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
    
    private static func fetchFabLocations() -> [FabLocation] {
        #if DEBUG
        let midwest = Region(name: "Midwest")
        return [
            .init(name: "Austin Plant", location: "Austin, TX"),
            .init(name: "Phoenix Plant", location: "Phoenix, AZ"),
            .init(name: "Denver Plant", location: "Denver, CO"),
            .init(name: "Detroit Plant", location: "Detroit, MI", region: midwest),
            .init(name: "Chicago Plant", location: "Chicago, IL", region: midwest),
            .init(name: "St. Louis Plant", location: "St. Louis, MO", region: midwest),
        ]
        #else
        // fetch from DB and process
        return []
        #endif
        
    }
    
}
