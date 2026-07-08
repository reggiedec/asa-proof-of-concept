//
//  GenericBar.swift
//  aSaP
//
//  Created by Dalton Fitzsimmons on 7/6/26.
//

import SwiftUI

/// Creates a generic bar for Inventory and fabrication screens
/// - Parameter cornerRadius: how round the bar is
/// - Parameter barFill: the color of the bar, can be a traditional color or gradient
/// - Parameter barHeight: maxHeight of the bar
/// - Parameter fillRatio: Width of the bar
struct GenericBar<Fill: ShapeStyle>: View {
    var cornerRadius: CGFloat
    var barFill: Fill
    var barHeight: CGFloat
    var fillRatio: CGFloat
    
    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(barFill)
            .shadow(color: .white.opacity(0.85), radius: 5)
            .frame(maxHeight: barHeight)
            .frame(width: fillRatio)
    }
}

#Preview {
    GeometryReader { geo in
        VStack {
            GenericBar(cornerRadius: 100, barFill: .red, barHeight: 25, fillRatio: geo.size.width)
            GenericBar(cornerRadius: 100, barFill: LinearGradient(
                colors: [
                    Color(.red),
                    Color(.blue),
                    Color(.purple)
                ],
                startPoint: .top,
                endPoint: .bottom
            ), barHeight: 25, fillRatio: 100)
        }
    }
}
