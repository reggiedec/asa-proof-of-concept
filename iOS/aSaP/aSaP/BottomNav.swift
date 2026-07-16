//
//  BottomNav.swift
//  aSaP
//
//  Created by Regine DeCossard on 7/15/26.
//

import SwiftUI

struct BottomNav: View {
    @Binding var selectedTab: Int

    private let activeColor = Color("BlueGradient")
    private let inactiveColor = Color("CharcoalBlack").opacity(0.38)

    private let tabs: [BottomNavItem] = [
        .init(title: "Home", systemImage: "house", tag: 0),
        .init(title: "Inventory", systemImage: "shippingbox", tag: 1),
        .init(title: "Fab", systemImage: "wrench", tag: 2),
        .init(title: "Shipping", systemImage: "truck.box.fill", tag: 3),
        .init(title: "Finance", systemImage: "dollarsign", tag: 4)
    ]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs) { tab in
                Button {
                    selectedTab = tab.tag
                } label: {
                    VStack(spacing: 6) {
                        Image(systemName: tab.systemImage)
                            .font(.system(size: 17, weight: .semibold))
                            .frame(width: 18, height: 18)

                        Text(tab.title)
                            .font(.beVietnam(.semiBold, size: 12))
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                    }
                    .foregroundStyle(selectedTab == tab.tag ? activeColor : inactiveColor)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(tab.title)
            }
        }
        .padding(.top, 1)
        .frame(maxWidth: .infinity)
        .background(.white)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(Color("CharcoalBlack").opacity(0.10))
                .frame(height: 1)
        }
        .shadow(color: .black.opacity(0.10), radius: 7.65, x: 0, y: -3)
    }
}

private struct BottomNavItem: Identifiable {
    let title: String
    let systemImage: String
    let tag: Int

    var id: Int { tag }
}

#Preview {
    @Previewable @State var selectedTab = 0

    BottomNav(selectedTab: $selectedTab)
}
