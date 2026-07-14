//
//  LoadOrderStatus.swift
//  aSaP
//
//  Created by Dalton Fitzsimmons on 7/13/26.
//

import SwiftUI

struct LOSDetails: Comparable {
    var title: String
    var location: String
    var weight: Double
    var shipments: Int
    var orders: Int
    var date: String
    var status: Status
    
    static func < (lhs: LOSDetails, rhs: LOSDetails) -> Bool {
        lhs.status < rhs.status
    }
    
    enum Status: Int, CaseIterable, Identifiable, Comparable {
        case delayed = 0
        case pending = 1
        case loading = 2
        case transit = 3
        case delivered = 4
        
        var id: Int { self.rawValue }
        var rawText: String {
            switch self {
            case .pending: return "Pending"
            case .transit: return "In Transit"
            case .delivered: return "Delivered"
            case .loading: return "Loading"
            case .delayed: return "Delayed"
            }
        }
        static func < (lhs: LOSDetails.Status, rhs: LOSDetails.Status) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
    }
    
    func pillColors() -> (Color, Color) {
        switch self.status {
        case .delayed:
            return (.trendTextRed, .backgroundRed)
        case .pending:
            return (.charcoalBlack, .backgroundBlack)
        case .loading:
            return (.blueGradient, .backgroundBlue)
        case .transit:
            return (.blueGradient, .backgroundBlue)
        case .delivered:
            return (.trendTextGreen, .backgroundGreen)
        }
    }
}

struct LoadOrderStatusWidget: WidgetProtocol {
    let id: UUID
    let name: String = "Load and Order Status"
    var isFavorite: Bool = false
    var statuses: [LOSDetails]
    
    private func LOSItem(for item: LOSDetails) -> some View {
        let (pillText, pillBackground) = item.pillColors()
        
        return HStack {
            VStack(alignment: .leading) {
                Text(item.title)
                    .foregroundStyle(.charcoalBlack)
                    .font(.headingThree)
                
                Text(item.location)
                    .foregroundStyle(.greyText)
                    .font(.thinSubheader)
                
                HStack(spacing: 10) {
                    Text("\(item.weight, specifier: "%.2f") Tons")
                        .foregroundStyle(.greyText)
                        .font(.thinSubheader)
                    Text("\(item.shipments) Shipments")
                        .foregroundStyle(.greyText)
                        .font(.thinSubheader)
                    Text("\(item.orders) Orders")
                        .foregroundStyle(.greyText)
                        .font(.thinSubheader)
                }
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(item.status.rawText)
                    .foregroundStyle(pillText)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 3)
                    .font(.pillText)
                    .background {
                        Capsule()
                            .foregroundStyle(pillBackground)
                    }
                Spacer()
                Text(item.date)
                    .font(.subHeader)
                    .foregroundStyle(.greyText)
                    .padding(.trailing, 12)
            }
        }
        .padding(.horizontal, 0)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, maxHeight: 85,alignment: .center)
    }
    
    var body: some View {
        let sorted = statuses.sorted()
        ScrollView {
            ForEach(Array(sorted.enumerated()), id: \.element.title) { idx, detail in
                LOSItem(for: detail)
                
                if idx < statuses.count - 1 {
                    Divider()
                }
            }
            .padding(.leading, AppVariables.widgetVariables.leadingPadding)
        }
        .frame(maxHeight: 320)
        
    }
}

#Preview {
    LoadOrderStatusWidget(id: UUID(), statuses: [
        LOSDetails(title: "Load 1", location: "Warehouse A", weight: 1200, shipments: 5, orders: 10, date: "6/29/26", status: .delayed),
        LOSDetails(title: "Load 2", location: "Warehouse B", weight: 800, shipments: 3, orders: 7, date: "6/39/26", status: .pending),
        LOSDetails(title: "Load 3", location: "Warehouse C", weight: 1500, shipments: 6, orders: 12, date: "ETA 12:55 pm", status: .loading),
        LOSDetails(title: "Load 4", location: "Warehouse D", weight: 1000, shipments: 4, orders: 8, date: "ETA 1:35 pm", status: .transit),
        LOSDetails(title: "Load 5", location: "Warehouse E", weight: 900, shipments: 2, orders: 5, date: "5/20/26", status: .delivered)
    ]).body
}
