//
//  DynamicGraph.swift
//  aSaP
//
//  Created by Dalton Fitzsimmons on 7/7/26.
//

import SwiftUI
import Charts

struct DynamicGraph: View {
    private(set) var items: [GraphItem]
    private let cornerRadius: CGFloat = 5
    private let maxGraphHeight: CGFloat = 120
    private let maxInfoHeight: CGFloat = 50
    @State private var selectedItem: String?
    
    private let identifierColor = Color(
        red: 233/255,
        green: 239/255,
        blue: 241/255,
        opacity: 1
    )
    
    @ViewBuilder
    private func detailHeader(for key: String) -> some View {
        if let selected = items.first(where: { $0.name == key }) {
            HStack(alignment: .center) {
                Text("\(String(format: "%.1f", selected.value)) Tons")
                    .font(Font.custom("BeVietnamPro-SemiBold", size: 12))
                    .foregroundStyle(.charcoalBlack)
            }
            .padding(6)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(identifierColor)
            }
            .padding(.horizontal)
        }
        EmptyView()
    }
    
    /*
     Charts notes
     - Can use .chartScrollableAxes(.horizontal) for scrolling
        .chartScrollableAxes(.horizontal)
        .chartXVisibleDomain(length: 5)
     */
    var body: some View {
        VStack {
            Chart {
                ForEach(items) {item in
                    BarMark(
                        x: .value("", item.name),
                        y: .value("Amount", item.value)
                    )
                    .foregroundStyle(item.fill)
                    .cornerRadius(cornerRadius)
                    
                }
            }
            .frame(height: maxGraphHeight)
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            .chartXAxis {
                AxisMarks(values: .automatic) { _ in
                    AxisGridLine().foregroundStyle(.clear)   // hide the grid line
                    AxisTick()                // keep ticks
                    AxisValueLabel()          // keep labels
                }
            }
            .chartXSelection(value: $selectedItem)
            .chartOverlay { proxy in
                GeometryReader { geo in
                    if let key = selectedItem, let xPos = proxy.position(forX: key) {
                        let plot = geo[proxy.plotAreaFrame]
                        let headerX = plot.origin.x + xPos
                        let headerYOffset: CGFloat = 35
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 0)
                                .fill(Color.white)
                                .frame(height: 50)
                                .position(x: geo.size.width / 2, y: plot.origin.y - headerYOffset)
                            
                            RoundedRectangle(cornerRadius: 0)
                                .fill(identifierColor)
                                .frame(width: 2, height: headerYOffset)
                                .position(x: headerX, y: plot.origin.y - headerYOffset / 2)
                            
                            detailHeader(for: key)
                                .position(x: headerX, y: plot.origin.y - headerYOffset)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    DynamicGraph(items: [
        .init(name: "A", value: 15, fill: LinearGradient(colors: [.blueGradient.opacity(0.7), .blueGradient, .blueGradient], startPoint: .top, endPoint: .bottom)),
        .init(name: "B", value: 15, fill: Color.grayBars),
        .init(name: "C", value: 15, fill: LinearGradient(colors: [.blueGradient.opacity(0.7), .blueGradient, .blueGradient], startPoint: .top, endPoint: .bottom)),
        .init(name: "D", value: 15, fill: Color.grayBars),
        .init(name: "E", value: 15, fill: LinearGradient(colors: [.blueGradient.opacity(0.7), .blueGradient, .blueGradient], startPoint: .top, endPoint: .bottom)),
        .init(name: "F", value: 15, fill: Color.grayBars),
        
        .init(name: "G", value: 15, fill: LinearGradient(colors: [.blueGradient.opacity(0.7), .blueGradient, .blueGradient], startPoint: .top, endPoint: .bottom)),
    ])
}

