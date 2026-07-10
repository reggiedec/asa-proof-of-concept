//
//  ContentView.swift
//  aSaP
//
//  Created by Dalton Fitzsimmons on 6/29/26.
//

import SwiftUI

struct ContentView: View {
    @Environment(AppState.self) private var appState
    @State private var selectedTab = 0
    @State private var favoriteGuide: Bool = false
    @State private var showNotifications: Bool = false
    @State private var showLocationSettings: Bool = false

    var body: some View {
        TabView(selection: $selectedTab) {
            // MARK: Home
            NavigationStack {
                pageContent(title: "Home") {
                    HomeView(selectedTab: $selectedTab, favoriteGuide: $favoriteGuide)
                }
            }
            .tabItem {
                Label("Home", systemImage: "house.fill") //icons present in SF Symbols, should be able to upload our own images too
            }
            .tag(0)

            // MARK: Inventory
            NavigationStack {
                pageContent(title: "Inventory") {
                    InventoryView(favoriteGuide: $favoriteGuide)
                }
            }
            .tabItem {
                Label("Inventory", systemImage: "shippingbox.fill")
            }
            .tag(1)

            // MARK: Fabrication
            NavigationStack {
                pageContent(title: "Fabrication") {
                    FabricationView()
                }
            }
            .tabItem {
                Label("Fabrication", systemImage: "scissors")
            }
            .tag(2)

            // MARK: Shipping
            NavigationStack {
                pageContent(title: "Shipping") {
                    ShippingView()
                }
            }
            .tabItem {
                Label("Shipping", systemImage: "truck.box.fill")
            }
            .tag(3)

            // MARK: Financials
            NavigationStack {
                pageContent(title: "Financials") {
                    FinancialsView()
                }
            }
            .tabItem {
                Label("Financials", systemImage: "dollarsign")
            }
            .tag(4)
        }
        .sheet(isPresented: $showNotifications){

        }
        .sheet(isPresented: $showLocationSettings, onDismiss: {
            // Fetch new API data w/ new saved locations in AppState
        }) {
            LocationSelector(locations: appState.locations, showLocations: $showLocationSettings)
                .presentationDragIndicator(.visible)
        }

    }

    private func pageContent<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        content()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("BackgroundColor"))
            .toolbar(.hidden, for: .navigationBar)
            .safeAreaInset(edge: .top, spacing: 0) {
                PageHeader(
                    title: title,
                    selectedLocationCount: appState.selectedLocationIDs.count,
                    onLocationTap: {
                        showLocationSettings = true
                    },
                    onNotificationsTap: {
                        showNotifications = true
                    }
                )
            }
    }
}

private struct PageHeader: View {
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

            Spacer(minLength: 12)

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

#Preview {
    @Previewable @State var appState = AppState()

    ContentView()
        .environment(appState)
}
