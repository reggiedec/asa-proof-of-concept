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
            id: "accounts-payable",
            title: "Accounts Payable",
            value: "$125k",
            status: .critical,
            actionTitle: "View"
        ),
        OverviewMetric(
            id: "total-weekly-sales",
            title: "Total Weekly Sales",
            value: "$352k"
        ),
        OverviewMetric(
            id: "accounts-receivable",
            title: "Accounts Receivable",
            value: "$113k",
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
