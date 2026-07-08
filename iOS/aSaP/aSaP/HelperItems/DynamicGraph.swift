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
    private let maxGraphHeight: CGFloat = 100
    
    /*
     Charts notes
     - Can use .chartScrollableAxes(.horizontal) for scrolling
     */
    var body: some View {
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
        .frame(maxHeight: maxGraphHeight)
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
    }
}

#Preview {
    DynamicGraph(items: [
        .init(name: "A", value: 15, fill: Color.blueGradient),
        .init(name: "B", value: 15, fill: Color.grayBars),
        .init(name: "C", value: 15, fill: LinearGradient(
            colors: [
                .blueGradient.opacity(0.7),
                .blueGradient,
                .blueGradient
            ],
            startPoint: .top,
            endPoint: .bottom
        ))
    ])
}
