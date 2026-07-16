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
    private func iconSize(for iconName: String) -> (CGFloat, CGFloat) {
        var width: CGFloat = 24
        var height: CGFloat = 24
        
        if iconName == "house" {
            width = 30
            height = 26
        } else if iconName == "shippingbox" {
            width = 26
            height = 26
        } else if iconName == "wrench" {
            width = 28
            height = 28
        } else if iconName == "truck.box.fill" {
            width = 34
            height = 24
        } else if iconName == "dollarsign" {
            width = 16
            height = 24
        }
        
        
        return (width, height)
      
        
    }

    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs) { tab in
                let (width,height ) = iconSize(for: tab.systemImage)
                Button {
                    selectedTab = tab.tag
                } label: {
                    VStack(spacing: 6) {
                        Image(systemName: tab.systemImage)
                            .resizable()
                            .font(.system(size: 17, weight: .semibold))
                            .frame(width: width, height: height)
                     

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
