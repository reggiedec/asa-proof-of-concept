//
//  ContentView.swift
//  aSaP
//
//  Created by Dalton Fitzsimmons on 6/29/26.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var favoriteGuide: Bool = false

    var body: some View {
        TabView(selection: $selectedTab) {
            // MARK: Home
            NavigationStack {
                HomeView(selectedTab: $selectedTab, favoriteGuide: $favoriteGuide)
                    .navigationTitle(Text("Home")) // Top header if wanted
            }
            .tabItem {
                Label("Home", systemImage: "house.fill") //icons present in SF Symbols, should be able to upload our own images too
            }
            .tag(0)
            
            // MARK: Inventory
            NavigationStack {
                InventoryView(favoriteGuide: $favoriteGuide)
            }
            .tabItem {
                Label("Inventory", systemImage: "shippingbox.fill")
            }
            .tag(1)
            
            // MARK: Fabrication
            NavigationStack {
                FabricationView()
            }
            .tabItem {
                Label("Fabrication", systemImage: "scissors")
            }
            .tag(2)
            
            // MARK: Shipping
            NavigationStack {
               ShippingView()
            }
            .tabItem {
                Label("Shipping", systemImage: "truck.box.fill")
            }
            .tag(3)
            
            // MARK: Financials
            NavigationStack {
                FinancialsView()
            }
            .tabItem {
                Label("Financials", systemImage: "dollarsign")
            }
            .tag(4)
        }
    }
}

#Preview {
    @Previewable @State var appState = AppState()
    
    ContentView()
        .environment(appState)
}
