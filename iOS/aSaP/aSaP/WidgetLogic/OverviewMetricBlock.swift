//
//  OverviewMetricBlock.swift
//  aSaP
//
//  Created by Regine DeCossard on 7/7/26.
//

import SwiftUI

struct OverviewMetric: Identifiable, Equatable {
    enum Status: Equatable {
        case normal
        case critical
    }

    let id: String
    let title: String
    let value: String
    let status: Status
    let actionTitle: String?

    init(
        id: String,
        title: String,
        value: String,
        status: Status = .normal,
        actionTitle: String? = nil
    ) {
        self.id = id
        self.title = title
        self.value = value
        self.status = status
        self.actionTitle = actionTitle
    }
}

struct OverviewMetricBlock: View {
    let metric: OverviewMetric

    private let cornerRadius: CGFloat = 5
    private let minHeight: CGFloat = 86
    private let horizontalPadding: CGFloat = 16
    private let verticalPadding: CGFloat = 14

    private var isCritical: Bool {
        metric.status == .critical
    }

    private var primaryTextColor: Color {
        isCritical ? .white : Color("CharcoalBlack")
    }

    private var secondaryTextColor: Color {
        isCritical ? .white.opacity(0.92) : Color("CharcoalBlack").opacity(0.72)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(metric.title)
                .font(Font.custom("BeVietnamPro-SemiBold", size: 11))
                .tracking(2)
                .foregroundStyle(secondaryTextColor)
                .textCase(.uppercase)
                .lineLimit(2)

            Spacer(minLength: 0)

            HStack(alignment: .lastTextBaseline) {
                Text(metric.value)
                    .font(Font.custom("BeVietnamPro-Bold", size: 30))
                    .foregroundStyle(primaryTextColor)
                    .minimumScaleFactor(0.72)
                    .lineLimit(1)

                Spacer(minLength: 8)

                if let actionTitle = metric.actionTitle {
                    Text(actionTitle)
                        .font(Font.custom("BeVietnamPro-SemiBold", size: 12))
                        .foregroundStyle(primaryTextColor)
                        .lineLimit(1)
                }
            }
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, verticalPadding)
        .frame(maxWidth: .infinity, minHeight: minHeight, alignment: .leading)
        .background {
            if isCritical {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color("GradientRedStart"),
                                Color("GradientRedEnd")
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            } else {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color("GrayBars"))
            }
        }
    }
}

struct OverviewMetricGrid: View {
    let metrics: [OverviewMetric]

    private var columnCount: Int {
        switch metrics.count {
        case 0...1:
            return 1
        case 2...3:
            return metrics.count
        default:
            return 2
        }
    }

    private var columns: [GridItem] {
        Array(
            repeating: GridItem(.flexible(), spacing: 12, alignment: .top),
            count: columnCount
        )
    }

    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: 14) {
            ForEach(metrics) { metric in
                OverviewMetricBlock(metric: metric)
            }
        }
    }
}

#Preview {
    OverviewMetricGrid(metrics: [
        OverviewMetric(id: "cash", title: "Cash on Hand", value: "$387k"),
        OverviewMetric(id: "ar", title: "Accounts Receivable", value: "$214k", actionTitle: "View"),
        OverviewMetric(id: "ap", title: "AP Aging 90+", value: "$125k", status: .critical, actionTitle: "View")
    ])
    .padding()
}
