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
    @Binding private var status: OverviewMetric.Status
    private let action: (OverviewMetric) -> Void

    private let cornerRadius: CGFloat = 6
    private let minHeight: CGFloat = 87
    private let horizontalPadding: CGFloat = 17
    private let verticalPadding: CGFloat = 17

    init(
        metric: OverviewMetric,
        status: Binding<OverviewMetric.Status>? = nil,
        action: @escaping (OverviewMetric) -> Void = { _ in }
    ) {
        self.metric = metric
        self._status = status ?? .constant(metric.status)
        self.action = action
    }

    private var isCritical: Bool {
        status == .critical
    }

    private var primaryTextColor: Color {
        isCritical ? .white : Color("CharcoalBlack")
    }

    private var secondaryTextColor: Color {
        isCritical ? .white.opacity(0.92) : Color("CharcoalBlack").opacity(0.72)
    }

    var body: some View {
        Button {
            action(metric)
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                Text(metric.title)
                    .font(Font.custom("BeVietnamPro-Medium", size: 10))
                    .tracking(1)
                    .foregroundStyle(secondaryTextColor)
                    .lineLimit(2)
                    .minimumScaleFactor(0.78)

                Spacer(minLength: 0)

                HStack(alignment: .lastTextBaseline) {
                    Text(metric.value)
                        .font(Font.custom("BeVietnamPro-Bold", size: 30))
                        .foregroundStyle(primaryTextColor)
                        .minimumScaleFactor(0.6)
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
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                } else {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(Color("BackgroundBlack"))
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(metric.title), \(metric.value)")
        .accessibilityValue(isCritical ? "Critical" : "Normal")
    }
}

struct OverviewMetricGrid: View {
    let metrics: [OverviewMetric]
    private let action: (OverviewMetric) -> Void

    init(
        metrics: [OverviewMetric],
        action: @escaping (OverviewMetric) -> Void = { _ in }
    ) {
        self.metrics = metrics
        self.action = action
    }

    private var columnCount: Int {
        switch metrics.count {
        case 0...1:
            return 1
        case 3:
            return 3
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
        LazyVGrid(columns: columns, alignment: .leading, spacing: 12) {
            ForEach(metrics) { metric in
                OverviewMetricBlock(metric: metric, action: action)
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
