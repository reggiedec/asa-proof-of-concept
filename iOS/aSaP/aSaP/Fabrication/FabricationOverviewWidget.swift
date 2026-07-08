//
//  FabricationOverviewWidget.swift
//  aSaP
//
//  Created by Regine DeCossard on 7/8/26.
//

import SwiftUI

struct FabricationOverviewWidget: WidgetProtocol {
    let id: UUID
    var name: String = "Fabrication Overview"
    var isFavorite: Bool

    private let metrics: [OverviewMetric] = [
        OverviewMetric(
            id: "active-jobs",
            title: "Active Jobs",
            value: "5"
        ),
        OverviewMetric(
            id: "machine-issues",
            title: "Machine Issues",
            value: "1",
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
    FabricationOverviewWidget().body
        .padding()
}
