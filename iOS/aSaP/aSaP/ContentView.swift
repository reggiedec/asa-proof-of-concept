//
//  ContentView.swift
//  aSaP
//
//  Created by Dalton Fitzsimmons on 6/29/26.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            // MARK: Home
            NavigationStack {
                HomeView()
                    .navigationTitle(Text("Home")) // Top header if wanted
            }
            .tabItem {
                Label("Home", systemImage: "house.fill") //icons present in SF Symbols, should be able to upload our own images too
            }
            
            // MARK: Inventory
            NavigationStack {
                InventoryView()
            }
            .tabItem {
                Label("Inventory", systemImage: "shippingbox.fill")
            }
            
            // MARK: Fabrication
            NavigationStack {
                FabricationView()
            }
            .tabItem {
                Label("Fabrication", systemImage: "scissors")
            }
            
            // MARK: Shipping
            NavigationStack {
               ShippingView()
            }
            .tabItem {
                Label("Shipping", systemImage: "truck.box.fill")
            }
            
            // MARK: Financials
            NavigationStack {
                FinancialsView()
            }
            .tabItem {
                Label("Financials", systemImage: "dollarsign")
            }
        }
    }
}

#Preview {
    @Previewable @State var appState = AppState()
    
    ContentView()
        .environment(appState)
}
