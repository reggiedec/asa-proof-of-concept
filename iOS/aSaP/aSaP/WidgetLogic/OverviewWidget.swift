//
//  OverviewWidget.swift
//  aSaP
//
//  Created by Regine DeCossard on 7/9/26.
//

import SwiftUI

struct OverviewWidget: WidgetProtocol {
    let id: UUID
    let name: String
    var isFavorite: Bool
    private let metrics: [OverviewMetric]
    private let action: (OverviewMetric) -> Void

    init(
        id: UUID = UUID(),
        name: String,
        metrics: [OverviewMetric],
        isFavorite: Bool = false,
        action: @escaping (OverviewMetric) -> Void = { _ in }
    ) {
        self.id = id
        self.name = name
        self.metrics = metrics
        self.isFavorite = isFavorite
        self.action = action
    }

    static func == (lhs: OverviewWidget, rhs: OverviewWidget) -> Bool {
        lhs.id == rhs.id
    }

    var body: some View {
        OverviewMetricGrid(metrics: metrics, action: action)
    }
}

#Preview {
    OverviewWidget(
        name: "Inventory Overview",
        metrics: [
            OverviewMetric(id: "sku-count", title: "# of SKUs", value: "10"),
            OverviewMetric(id: "in-stock", title: "In Stock", value: "6"),
            OverviewMetric(id: "alerts", title: "Alerts", value: "4", status: .critical, actionTitle: "View")
        ]
    )
    .body
    .padding()
}
