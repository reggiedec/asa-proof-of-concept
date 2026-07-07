//
//  FinancialOverviewWidget.swift
//  aSaP
//
//  Created by Regine DeCossard on 7/7/26.
//

import SwiftUI

struct FinancialOverviewWidget: WidgetProtocol {
    let id: UUID
    var name: String = "Financial Overview"
    var isFavorite: Bool

    private let metrics: [OverviewMetric] = [
        OverviewMetric(
            id: "cash-on-hand",
            title: "Cash on Hand",
            value: "$387k"
        ),
        OverviewMetric(
            id: "accounts-receivable",
            title: "Accounts Receivable",
            value: "$214k",
            actionTitle: "View"
        ),
        OverviewMetric(
            id: "ap-aging-90-plus",
            title: "AP Aging 90+ Days",
            value: "$125k",
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
    FinancialOverviewWidget().body
        .padding()
}
