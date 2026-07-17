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
    @State private var showAccountSheet: Bool = false
    @State private var showLocationSettings: Bool = false
    @State private var notificationVersions = AppNotification.randomizedVersions()

    var body: some View {
        Group {
            if showNotifications {
                notificationsSurface
            } else {
                mainContent
            }
        }
        .animation(.easeInOut(duration: 0.18), value: showNotifications)
        .sheet(isPresented: $showAccountSheet) {
            AccountSheet(isPresented: $showAccountSheet)
                .presentationDetents([.height(390)])
                .presentationDragIndicator(.automatic)
        }
        .sheet(isPresented: $showLocationSettings, onDismiss: {
            // Fetch new API data w/ new saved locations in AppState
        }) {
            LocationSelector(locations: appState.locations, showLocations: $showLocationSettings)
                .presentationDragIndicator(.visible)
        }

    }

    private var mainContent: some View {
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
        .toolbar(.hidden, for: .tabBar)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            BottomNav(selectedTab: $selectedTab)
        }
    }

    private var notificationsSurface: some View {
        VStack(spacing: 0) {
            ZStack {
                Text("Notifications")
                    .font(.boldeighteen)
                    .foregroundStyle(Color("CharcoalBlack"))

                HStack {
                    Button {
                        showNotifications = false
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(Color("CharcoalBlack"))
                            .frame(width: 36, height: 36)
                            .background {
                                Circle()
                                    .fill(Color("BackgroundBlack"))
                            }
                    }
                    .buttonStyle(.plain)

                    Spacer()

                    Button {
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(Color("CharcoalBlack"))
                            .frame(width: 36, height: 36)
                            .background {
                                Circle()
                                    .fill(Color("BackgroundBlack"))
                            }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .padding(.bottom, 16)
            .frame(maxWidth: .infinity)
            .background(.white)

            NotificationsView(
                showNotifications: $showNotifications,
                notifications: notificationVersions
            )
            .frame(width: 370, alignment: .topLeading)
            .padding(.top, 18)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("BackgroundColor").ignoresSafeArea())
        .transition(.opacity)
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
                    selectedLocationCount: appState.selectedLocationIDs.count,
                    notificationCount: notificationVersions.count,
                    hasCriticalNotifications: notificationVersions.contains(where: \.isCritical),
                    onLocationTap: {
                        showLocationSettings = true
                    },
                    onNotificationsTap: {
                        showNotifications.toggle()
                    }
                ) {
                    if title == "Home" {
                        Button {
                            showAccountSheet = true
                        } label: {
                            UserAvatarBubble(initials: "JD")
                        }
                        .buttonStyle(.plain)
                    } else {
                        PageHeaderTitle(title: title)
                    }
                }
            }
    }
}

#Preview {
    @Previewable @State var appState = AppState()

    ContentView()
        .environment(appState)
}
