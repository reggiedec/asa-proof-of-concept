//
//  BottomNav.swift
//  aSaP
//
//  Created by Regine DeCossard on 7/15/26.
//

import SwiftUI


private struct BottomNavItem: Identifiable {
    let title: String
    let selectedIcon: String
    let defaultIcon: String
    let tag: Int

    var id: Int { tag }
}

struct BottomNav: View {
    @Binding var selectedTab: Int
    
    private let activeColor = Color("BlueGradient")
    private let inactiveColor = Color("CharcoalBlack").opacity(0.38)
    
    private let tabs: [BottomNavItem] = [
        .init(title: "Home", selectedIcon: "HomeBlue", defaultIcon: "HomeGray", tag: 0),
        .init(title: "Inventory", selectedIcon: "InvBlue", defaultIcon: "InvGray", tag: 1),
        .init(title: "Fab", selectedIcon: "FabBlue", defaultIcon: "FabGray", tag: 2),
        .init(title: "Shipping", selectedIcon: "ShippingBlue", defaultIcon: "ShippingGray", tag: 3),
        .init(title: "Finance", selectedIcon: "FinBlue", defaultIcon: "FinGray", tag: 4)
    ]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs) { tab in
                Button {
                    selectedTab = tab.tag
                } label: {
                    VStack(spacing: 6) {
                        Image(selectedTab == tab.tag ? tab.selectedIcon : tab.defaultIcon)
                            .resizable()
                            .font(.system(size: 17, weight: .semibold))
                            .frame(width: 22, height: 22)
                     

                        Text(tab.title)
                            .font(.progressTiny)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                    }
                    .foregroundStyle(selectedTab == tab.tag ? activeColor : inactiveColor)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 12)
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

#Preview {
    @Previewable @State var selectedTab = 0

    BottomNav(selectedTab: $selectedTab)
}
