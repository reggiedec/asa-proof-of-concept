//
//  Notifications.swift
//  aSaP
//
//  Created by Regine DeCossard on 7/16/26.
//

import SwiftUI

enum NotificationPriority {
    case critical
    case standard

    var cardFill: AnyShapeStyle {
        switch self {
        case .critical:
            return AnyShapeStyle(
                LinearGradient(
                    colors: [
                        .gradientRedStart,
                        .gradientRedEnd,
                        .gradientRedEnd
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        case .standard:
            return AnyShapeStyle(Color.white)
        }
    }

    var primaryText: Color {
        switch self {
        case .critical:
            return .white
        case .standard:
            return .charcoalBlack
        }
    }

    var secondaryText: Color {
        switch self {
        case .critical:
            return .white.opacity(0.92)
        case .standard:
            return .charcoalBlack.opacity(0.78)
        }
    }

    var indicator: Color {
        switch self {
        case .critical:
            return .white
        case .standard:
            return Color(red: 0.00, green: 0.34, blue: 0.43)
        }
    }

    var pillFill: Color {
        switch self {
        case .critical:
            return .white.opacity(0.22)
        case .standard:
            return .backgroundBlack
        }
    }
}

enum NotificationTimelineState {
    case resolved
    case current
    case pending

    var fill: Color {
        switch self {
        case .resolved, .pending:
            return .white
        case .current:
            return .trendTextRed
        }
    }

    var stroke: Color {
        switch self {
        case .resolved, .pending:
            return Color("CharcoalBlack").opacity(0.26)
        case .current:
            return .trendTextRed
        }
    }
}

enum NotificationTimeScope: String, CaseIterable {
    case past = "Past"
    case current = "Current"
    case future = "Future"
}

enum NotificationCategory {
    case shipping
    case inventory
    case fabrication
    case financials

    func iconName(for priority: NotificationPriority) -> String {
        switch (self, priority) {
        case (.shipping, .critical):
            return "ShippingWhite"
        case (.shipping, .standard):
            return "ShippingGray"
        case (.inventory, .critical):
            return "InvWhite"
        case (.inventory, .standard):
            return "InvGray"
        case (.fabrication, .critical):
            return "FabWhite"
        case (.fabrication, .standard):
            return "FabGray"
        case (.financials, .critical):
            return "FinWhite"
        case (.financials, .standard):
            return "FinGray"
        }
    }
}

protocol NotificationPresentable: Identifiable {
    var subjectID: String { get }
    var problemTitle: String { get }
    var description: String { get }
    var time: String { get }
    var priority: NotificationPriority { get }
    var scope: NotificationTimeScope { get }
    var category: NotificationCategory { get }
    var timeline: [NotificationTimelineEntry] { get }
}

struct NotificationTimelineEntry: Identifiable {
    let id = UUID()
    let date: String
    let message: String
    let state: NotificationTimelineState
}

struct AppNotification: NotificationPresentable {
    let id = UUID()
    let subjectID: String
    let problemTitle: String
    let description: String
    let time: String
    let priority: NotificationPriority
    let scope: NotificationTimeScope
    let category: NotificationCategory
    let startsExpanded: Bool
    let timeline: [NotificationTimelineEntry]
}

struct NotificationsView: View {
    @Binding var showNotifications: Bool
    @State private var expandedIDs: Set<UUID>

    private let notificationVersions: [AppNotification]

    init(showNotifications: Binding<Bool>, notifications: [AppNotification] = AppNotification.randomizedVersions()) {
        self._showNotifications = showNotifications
        self.notificationVersions = notifications
        self._expandedIDs = State(initialValue: Set(notifications.filter(\.startsExpanded).map(\.id)))
    }

    var body: some View {
        Group {
            if notificationVersions.count > 2 {
                ScrollView(showsIndicators: false) {
                    notificationCards
                        .padding(.bottom, 8)
                }
                .frame(maxHeight: 560, alignment: .topLeading)
            } else {
                notificationCards
            }
        }
        .frame(width: 370, alignment: .topLeading)
    }

    private var notificationCards: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(notificationVersions) { notification in
                NotificationCard(
                    notification: notification,
                    stackedVersionCount: notification.timeline.count,
                    isExpanded: expandedIDs.contains(notification.id)
                ) {
                    if expandedIDs.contains(notification.id) {
                        expandedIDs.remove(notification.id)
                    } else {
                        expandedIDs.insert(notification.id)
                    }
                }
            }
        }
    }
}

private extension View {
    func notificationShell(cornerRadius: CGFloat) -> some View {
        self
            .background {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.white)
                    .shadow(color: .black.opacity(0.22), radius: 4, x: 0, y: 2)
            }
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

struct NotificationCard<NotificationData: NotificationPresentable>: View {
    let notification: NotificationData
    let stackedVersionCount: Int
    let isExpanded: Bool
    let onToggle: () -> Void

    private var cardRadius: CGFloat { 6 }

    var body: some View {
        Group {
            if isExpanded {
                expandedCard
            } else {
                collapsedCardStack
            }
        }
        .frame(width: 370, alignment: .topLeading)
        .animation(.easeInOut(duration: 0.18), value: isExpanded)
    }

    private var expandedCard: some View {
        VStack(spacing: 0) {
            topContent

            timelineContent
                .transition(.opacity.combined(with: .move(edge: .top)))
        }
        .notificationShell(cornerRadius: cardRadius)
    }

    private var collapsedCardStack: some View {
        VStack(alignment: .leading, spacing: -58) {
            topContent
                .notificationShell(cornerRadius: cardRadius)
                .zIndex(2)

            if visibleStackDepth >= 1 {
                collapsedStackLayer(widthOffset: 12, opacity: 0.82)
                    .zIndex(1)
            }

            if visibleStackDepth >= 2 {
                collapsedStackLayer(widthOffset: 24, opacity: 0.62)
                    .zIndex(0)
            }
        }
        .padding(0)
        .frame(width: 370, alignment: .topLeading)
    }

    private var visibleStackDepth: Int {
        min(2, max(0, stackedVersionCount - 1))
    }

    private func collapsedStackLayer(widthOffset: CGFloat, opacity: Double) -> some View {
        RoundedRectangle(cornerRadius: cardRadius)
            .fill(Color.white.opacity(opacity))
            .overlay {
                RoundedRectangle(cornerRadius: cardRadius)
                    .stroke(Color("CharcoalBlack").opacity(0.1), lineWidth: 1)
            }
            .shadow(color: .black.opacity(0.12), radius: 3, x: 0, y: 2)
            .frame(width: 370 - widthOffset, height: 72)
            .frame(width: 370, alignment: .center)
    }

    private var topContent: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(notification.category.iconName(for: notification.priority))
                .resizable()
                .scaledToFit()
                .frame(width: 28, height: 28)

            VStack(alignment: .leading, spacing: 2) {
                Text(notification.subjectID)
                    .font(.boldfourteen)
                    .foregroundStyle(notification.priority.primaryText)
                    .lineLimit(1)

                Text(notification.problemTitle)
                    .font(.semiBoldSubheader)
                    .foregroundStyle(notification.priority.secondaryText)
                    .lineLimit(1)

                Text(notification.description)
                    .font(.semiBoldSubheader)
                    .foregroundStyle(notification.priority.secondaryText)
                    .lineLimit(1)
            }

            Spacer(minLength: 8)

            VStack(alignment: .trailing, spacing: 6) {
                Circle()
                    .fill(notification.priority.indicator)
                    .frame(width: 8, height: 8)

                Text(notification.time)
                    .font(.semiBoldSubheader)
                    .foregroundStyle(notification.priority.primaryText)
                    .lineLimit(1)

                Button(action: onToggle) {
                    HStack(spacing: 8) {
                        Text(notification.scope.rawValue)
                            .font(.toggleTex)
                            .foregroundStyle(notification.priority.primaryText)

                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(notification.priority.primaryText)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(notification.priority.pillFill)
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background {
            Rectangle()
                .fill(notification.priority.cardFill)
        }
    }

    private var timelineContent: some View {
        VStack(spacing: 0) {
            ForEach(Array(notification.timeline.enumerated()), id: \.element.id) { index, entry in
                HStack(alignment: .top, spacing: 12) {
                    VStack(spacing: 0) {
                        Circle()
                            .fill(entry.state.fill)
                            .overlay {
                                Circle()
                                    .stroke(entry.state.stroke, lineWidth: 1)
                            }
                            .frame(width: 12, height: 12)

                        if index < notification.timeline.count - 1 {
                            Rectangle()
                                .fill(Color("CharcoalBlack").opacity(0.18))
                                .frame(width: 1, height: 34)
                        }
                    }
                    .padding(.top, 3)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(entry.date)
                            .font(.semiBoldSubheader)
                            .foregroundStyle(.greyText)

                        Text(entry.message)
                            .font(.thinSubheader)
                            .foregroundStyle(.charcoalBlack)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 16)
        .background(.white)
    }
}

extension AppNotification {
    var isCritical: Bool {
        if case .critical = priority {
            return true
        }

        return false
    }

    static func randomizedVersions() -> [AppNotification] {
        let shuffled = examples.shuffled()
        let count = Int.random(in: 1...examples.count)
        let versions = Array(shuffled.prefix(count))

        return versions.sorted { first, second in
            if first.isCritical == second.isCritical {
                return false
            }

            return first.isCritical && !second.isCritical
        }
    }

    static let examples: [AppNotification] = [
        .init(
            subjectID: "SH-1283",
            problemTitle: "Shipping Exception",
            description: "Shipment is delayed.",
            time: "00:00 PM",
            priority: .critical,
            scope: .past,
            category: .shipping,
            startsExpanded: false,
            timeline: Self.shippingTimeline
        ),
        .init(
            subjectID: "INV-0441",
            problemTitle: "Inventory Threshold",
            description: "#8 Rebar is below minimum.",
            time: "03:20 PM",
            priority: .critical,
            scope: .past,
            category: .inventory,
            startsExpanded: false,
            timeline: Self.inventoryTimeline
        ),
        .init(
            subjectID: "FAB-2217",
            problemTitle: "Machine Downtime",
            description: "CNC line requires operator review.",
            time: "02:45 PM",
            priority: .standard,
            scope: .current,
            category: .fabrication,
            startsExpanded: false,
            timeline: Self.fabricationTimeline
        ),
        .init(
            subjectID: "EST-6020",
            problemTitle: "Estimate Approval",
            description: "Margin changed after material update.",
            time: "11:15 AM",
            priority: .standard,
            scope: .future,
            category: .financials,
            startsExpanded: false,
            timeline: Self.financialTimeline
        )
    ]

    private static let shippingTimeline: [NotificationTimelineEntry] = [
        .init(date: "Mar. 3, 2026 • 3pm", message: "Carrier confirmed the load missed its scheduled departure.", state: .current),
        .init(date: "Mar. 3, 2026 • 4pm", message: "Dispatch reassigned the shipment to the next available truck.", state: .pending),
        .init(date: "Mar. 3, 2026 • 5pm", message: "Customer notification is pending revised delivery confirmation.", state: .pending)
    ]

    private static let inventoryTimeline: [NotificationTimelineEntry] = [
        .init(date: "Mar. 3, 2026 • 10am", message: "Stock dropped within 15% of the required minimum.", state: .resolved),
        .init(date: "Mar. 3, 2026 • 1pm", message: "Inventory fell below the minimum threshold.", state: .current),
        .init(date: "Mar. 3, 2026 • 3pm", message: "Reorder request is waiting for purchasing approval.", state: .pending)
    ]

    private static let fabricationTimeline: [NotificationTimelineEntry] = [
        .init(date: "Mar. 3, 2026 • 12pm", message: "Machine output slowed below the target run rate.", state: .resolved),
        .init(date: "Mar. 3, 2026 • 2pm", message: "Operator paused the CNC line for inspection.", state: .resolved),
        .init(date: "Mar. 3, 2026 • 4pm", message: "Maintenance sign-off is required before resuming production.", state: .current)
    ]

    private static let financialTimeline: [NotificationTimelineEntry] = [
        .init(date: "Mar. 2, 2026 • 9am", message: "Material pricing changed after the first estimate draft.", state: .resolved),
        .init(date: "Mar. 2, 2026 • 2pm", message: "Projected margin moved outside the approval range.", state: .current),
        .init(date: "Mar. 4, 2026 • 9am", message: "Approver review is scheduled before the quote is sent.", state: .pending)
    ]
}

#Preview {
    @Previewable @State var showNotifications = true

    NotificationsView(showNotifications: $showNotifications)
}
