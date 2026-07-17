//
//  PageHeader.swift
//  aSaP
//
//  Created by Regine DeCossard on 7/10/26.
//

import SwiftUI

struct PageHeader<LeadingContent: View>: View {
    let selectedLocationCount: Int
    let notificationCount: Int
    let hasCriticalNotifications: Bool
    let onLocationTap: () -> Void
    let onNotificationsTap: () -> Void
    let leadingContent: LeadingContent

    private let horizontalPadding: CGFloat = 28
    private let topPadding: CGFloat = 24
    private let bottomPadding: CGFloat = 16

    init(
        selectedLocationCount: Int,
        notificationCount: Int = 0,
        hasCriticalNotifications: Bool = false,
        onLocationTap: @escaping () -> Void,
        onNotificationsTap: @escaping () -> Void,
        @ViewBuilder leadingContent: () -> LeadingContent
    ) {
        self.selectedLocationCount = selectedLocationCount
        self.notificationCount = notificationCount
        self.hasCriticalNotifications = hasCriticalNotifications
        self.onLocationTap = onLocationTap
        self.onNotificationsTap = onNotificationsTap
        self.leadingContent = leadingContent()
    }

    var body: some View {
        HStack(alignment: .center) {
            leadingContent

            Spacer()

            PageHeaderControls(
                selectedLocationCount: selectedLocationCount,
                notificationCount: notificationCount,
                hasCriticalNotifications: hasCriticalNotifications,
                onLocationTap: onLocationTap,
                onNotificationsTap: onNotificationsTap
            )
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.top, topPadding)
        .padding(.bottom, bottomPadding)
        .frame(maxWidth: .infinity, alignment: .center)
        .background(.white)
    }
}

struct UserAvatarBubble: View {
    let initials: String

    var body: some View {
        Text(initials)
            .font(Font.custom("BeVietnamPro-Bold", size: 11))
            .foregroundStyle(.white)
            .frame(width: 32, height: 32)
            .background {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color("BlueGradient").opacity(0.7),
                                Color("BlueGradient")
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            }
            .accessibilityLabel("User profile")
    }
}

struct PageHeaderTitle: View {
    let title: String

    var body: some View {
        Text(title)
            .font(Font.custom("BeVietnamPro-Bold", size: 22))
            .foregroundStyle(Color("CharcoalBlack"))
            .lineLimit(1)
            .minimumScaleFactor(0.75)
    }
}

private struct PageHeaderPreview: View {
    var body: some View {
        PageHeader(
            selectedLocationCount: 6,
            onLocationTap: {},
            onNotificationsTap: {}
        ) {
            UserAvatarBubble(initials: "JD")
        }
    }
}

#Preview {
    PageHeaderPreview()
}

private struct PageHeaderControls: View {
    let selectedLocationCount: Int
    let notificationCount: Int
    let hasCriticalNotifications: Bool
    let onLocationTap: () -> Void
    let onNotificationsTap: () -> Void

    private let controlBackground = Color("BackgroundBlack")
    private var notificationBadgeFill: AnyShapeStyle {
        if hasCriticalNotifications {
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
        }

        return AnyShapeStyle(Color.white)
    }

    var body: some View {
        HStack(spacing: 12) {
            Spacer()
            locationsButton
            notificationsButton
        }
    }

    private var locationsButton: some View {
        Button(action: onLocationTap) {
            HStack(spacing: 6) {
                Image(systemName: "mappin.circle")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(Color("BlueGradient"))

                Text("\(selectedLocationCount) Locations")
                    .font(Font.custom("BeVietnamPro-Medium", size: 11))
                    .foregroundStyle(Color("CharcoalBlack"))

                Image(systemName: "chevron.down")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(Color("CharcoalBlack"))
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background {
                Capsule()
                    .fill(controlBackground)
            }
        }
        .buttonStyle(.plain)
    }

    private var notificationsButton: some View {
        Button(action: onNotificationsTap) {
            ZStack(alignment: .topTrailing) {
                Image(systemName: "bell")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(Color("CharcoalBlack"))
                    .frame(width: 32, height: 32)
                    .background {
                        Circle()
                            .fill(controlBackground)
                    }

                if notificationCount > 0 {
                    Text("\(notificationCount)")
                        .font(.barGraphTons)
                        .foregroundStyle(hasCriticalNotifications ? .white : Color("CharcoalBlack"))
                        .frame(minWidth: 15, minHeight: 15)
                        .padding(.horizontal, 3)
                        .background {
                            Capsule()
                                .fill(notificationBadgeFill)
                                .overlay {
                                    Capsule()
                                        .stroke(Color("CharcoalBlack").opacity(0.12), lineWidth: 1)
                                }
                        }
                        .offset(x: 6, y: -5)
                }
            }
        }
        .buttonStyle(.plain)
    }
}
