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

#Preview {
    @Previewable @State var appState = AppState()

    ContentView()
        .environment(appState)
}
