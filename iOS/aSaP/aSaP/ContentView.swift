//
//  ContentView.swift
//  aSaP
//
//  Created by Dalton Fitzsimmons on 6/29/26.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    /// Basic function used to create the nav bar
    /// - Parameter name: name of the tab it represents
    /// - Returns: basic starter view w/ custom name
    func tempView(name: String) -> some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("\(name)")
        }
        .padding()
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // MARK: Home
            NavigationStack {
                tempView(name: "Home") // TODO: Replace w/ actual page once created
                    .navigationTitle(Text("Home")) // Top header if wanted
            }
            .tabItem {
                Label("Home", systemImage: "house.fill") //icons present in SF Symbols, should be able to upload our own images too
            }
            
            // MARK: Inventory
            NavigationStack {
                tempView(name: "Inventory") // TODO: Replace w/ actual page once created
            }
            .tabItem {
                Label("Inventory", systemImage: "shippingbox.fill")
            }
            
            // MARK: Fabrication
            NavigationStack {
                tempView(name: "Fabrication") // TODO: Replace w/ actual page once created
            }
            .tabItem {
                Label("Fabrication", systemImage: "scissors")
            }
            
            // MARK: Shipping
            NavigationStack {
                tempView(name: "Shipping") // TODO: Replace w/ actual page once created
            }
            .tabItem {
                Label("Shipping", systemImage: "truck.box.fill")
            }
            
            // MARK: Financials
            NavigationStack {
                tempView(name: "Financials") // TODO: Replace w/ actual page once created
            }
            .tabItem {
                Label("Financials", systemImage: "dollarsign")
            }
        }
    }
}

#Preview {
    ContentView()
}
