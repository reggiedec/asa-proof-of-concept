//
//  ShippingOverviewWidget.swift
//  aSaP
//
//  Created by Regine DeCossard on 7/8/26.
//

import SwiftUI

struct ShippingOverviewWidget: WidgetProtocol {
    let id: UUID
    var name: String = "Shipping Overview"
    var isFavorite: Bool

    private let metrics: [OverviewMetric] = [
        OverviewMetric(
            id: "active-loads",
            title: "Active Loads",
            value: "43"
        ),
        OverviewMetric(
            id: "tonnage",
            title: "Tonnage",
            value: "1.8k"
        ),
        OverviewMetric(
            id: "in-transit",
            title: "In Transit",
            value: "8"
        ),
        OverviewMetric(
            id: "shipping-exceptions",
            title: "Shipping Exceptions",
            value: "3",
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
    ShippingOverviewWidget().body
        .padding()
}
