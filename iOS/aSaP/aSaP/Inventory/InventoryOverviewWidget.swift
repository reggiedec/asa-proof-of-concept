//
//  InventoryOverviewWidget.swift
//  aSaP
//
//  Created by Regine DeCossard on 7/8/26.
//

import SwiftUI

struct InventoryOverviewWidget: WidgetProtocol {
    let id: UUID
    var name: String = "Inventory Overview"
    var isFavorite: Bool

    private let metrics: [OverviewMetric] = [
        OverviewMetric(
            id: "sku-count",
            title: "# of SKUs",
            value: "10"
        ),
        OverviewMetric(
            id: "in-stock",
            title: "In Stock",
            value: "6"
        ),
        OverviewMetric(
            id: "inventory-alerts",
            title: "Alerts",
            value: "4",
            status: .critical,
            actionTitle: "View"
        )
    ]

    init(id: UUID = UUID(), isFavorite: Bool = false) {
        self.id = id
        self.isFavorite = isFavorite
    }

    var body: some View {
        OverviewMetricGrid(metrics: metrics)
    }
}

#Preview {
    InventoryOverviewWidget().body
        .padding()
}
