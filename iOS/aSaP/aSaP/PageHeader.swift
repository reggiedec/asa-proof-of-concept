//
//  PageHeader.swift
//  aSaP
//
//  Created by Regine DeCossard on 7/10/26.
//

import SwiftUI

struct PageHeader: View {
    let selectedLocationCount: Int
    let onLocationTap: () -> Void
    let onNotificationsTap: () -> Void

    private let horizontalPadding: CGFloat = 28
    private let topPadding: CGFloat = 24
    private let bottomPadding: CGFloat = 16

    var body: some View {
        HStack(alignment: .center) {
            userBubble

            Spacer()

            PageHeaderControls(
                selectedLocationCount: selectedLocationCount,
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

    private var userBubble: some View {
        Text("JD")
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

private struct PageHeaderControls: View {
    let selectedLocationCount: Int
    let onLocationTap: () -> Void
    let onNotificationsTap: () -> Void

    private let controlBackground = Color("BackgroundBlack")

    var body: some View {
        HStack(spacing: 12) {
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
            Image(systemName: "bell")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Color("CharcoalBlack"))
                .frame(width: 32, height: 32)
                .background {
                    Circle()
                        .fill(controlBackground)
                }
        }
        .buttonStyle(.plain)
    }
}
