//
//  PageHeader.swift
//  aSaP
//
//  Created by Regine DeCossard on 7/10/26.
//

import SwiftUI

struct PageHeader: View {
    let title: String
    let selectedLocationCount: Int
    let onLocationTap: () -> Void
    let onNotificationsTap: () -> Void

    private let horizontalPadding: CGFloat = 28
    private let topPadding: CGFloat = 24
    private let bottomPadding: CGFloat = 16
    private let titleColor = Color(red: 0.07, green: 0.09, blue: 0.15)

    var body: some View {
        HStack(alignment: .center) {
            Text(title)
                .font(Font.custom("BeVietnamPro-Bold", size: 22))
                .foregroundStyle(titleColor)
                .lineLimit(1)
                .minimumScaleFactor(0.75)

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
}

private struct PageHeaderControls: View {
    let selectedLocationCount: Int
    let onLocationTap: () -> Void
    let onNotificationsTap: () -> Void

    private let controlBackground = Color("BackgroundBlack")

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
                    .font(.subHeader)
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
