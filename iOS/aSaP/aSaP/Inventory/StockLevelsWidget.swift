//
//  StockLevelsWidget.swift
//  aSaP
//
//  Created by Dalton Fitzsimmons on 7/2/26.
//

import SwiftUI

struct StockLevelsWidget: WidgetProtocol {
    let id: UUID
    var name: String = "Stock Levels"
    var isFavorite: Bool = false // Check if this causes issues
    private(set) var stockItems : [StockItem]
    
    static func == (lhs: StockLevelsWidget, rhs: StockLevelsWidget) -> Bool {
        lhs.id == rhs.id
    }
    // Need: Bar, stock item name, size pill, overflow amount, explicit count
    
    /// Creates pill for the Stock Item Levels
    /// - Parameter stockItem: a specific stock item
    /// - Returns: a view representing the level the inventory is at
    private func overflowPill(stockItem: StockItem) -> some View {
        let (textColor, backgroundColor) = stockItem.getLevelColors()

        return Text(stockItem.level.description)
            .font(.pillText)
            .foregroundStyle(textColor)
            .padding(.vertical, 4)
            .padding(.horizontal, 11)
            .background {
                RoundedRectangle(cornerRadius: 100)
                    .fill(backgroundColor)
            }
    }
    
    /// Tag that states where the system designated min value is
    /// - Returns: simple view for this tag
    private func minTag(stockItem: StockItem) -> some View {
        return ZStack {
            Circle()
                .frame(width: 4)
            RoundedRectangle(cornerRadius: 100)
                .frame(width: 1, height: 12)
                .padding(.top, 12)
                .padding(.trailing, 0.5)
            Text("\((String(format: "%.1f", stockItem.minimum))) Tons")
                .font(.progressTiny)
                .padding(.top, 40)
        }
    }
    
    /// The bar of Stock items for the stock levels widget
    /// - Parameter stockItem: item getting displayed
    /// - Returns: a visual representation of stock level for a specific item
    private func progressBar(stockItem: StockItem) -> some View {
        let barSquish: CGFloat = 0
        let overflowPercentage = stockItem.calculateOverflowPercentage()
        let fillRatio = min(stockItem.quantity / stockItem.minimum, 1.0)
        let (gradientStart, gradientEnd): (Color, Color) = {
            switch stockItem.level {
            case .warning:
                return (Color("GradientRedStart"), Color("GradientRedEnd"))
            case .low:
                return (Color("CharcoalBlack").opacity(0.70), Color("CharcoalBlack"))
            case .high:
                return (Color("GradientGreenStart"), Color("GradientGreenEnd"))
            }
        }()
        
        func mainWidth(width: CGFloat) -> CGFloat {
            // width * (1.0 / 3.0) * fillRatio is how I get first third, do this with percentage
            // get overflow percentage % 100
            var remainder = overflowPercentage
            let third = width * (1.0 / 3.0)
            var barSize: CGFloat = third
            if overflowPercentage > 100 {
                barSize += third
                remainder -= 100
                print("\(barSize)")
            }
            print("\(width), \(third)")
            print("\(remainder), \(overflowPercentage)")
            
            barSize += (third * (CGFloat(remainder) / 100))
            print("\(barSize)\n")
            
            return barSize
        }
        
        return HStack {
            RoundedRectangle(cornerRadius: 100)
                .fill(Color("GrayBars"))
                .padding(.vertical, barSquish) // squishes the bar
                .frame(maxHeight: 12)
                .overlay {
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            // stripped
                            if overflowPercentage > 0 {
                                GenericBar(
                                    cornerRadius: 100,
                                    barFill: LinearGradient(
                                        colors: [
                                            Color(gradientStart),
                                            Color(gradientEnd),
                                            Color(gradientEnd)
                                        ],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    ),
                                    barHeight: 100,
                                    fillRatio: mainWidth(width: geo.size.width)
                                )
                                .overlay {
                                    HStack(spacing: 12) {
                                        ForEach(0..<20) {_ in
                                            Rectangle()
                                                .fill(.white.opacity(0.3))
                                                .frame(width: 10, height: 20) // added height to fix gap at top and bottom
                                                .rotationEffect(.degrees(15))
                                        }
                                    }
                                    .frame(width:mainWidth(width: geo.size.width))
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                }
                            }
                            // solid color
                            HStack {
                                GenericBar(
                                    cornerRadius: 100,
                                    barFill: LinearGradient(
                                                colors: [
                                                    Color(gradientStart),
                                                    Color(gradientEnd),
                                                    Color(gradientEnd)
                                                ],
                                                startPoint: .top,
                                                endPoint: .bottom
                                            ),
                                    barHeight: 100,
                                    fillRatio: geo.size.width * (1.0 / 3.0) * fillRatio
                                )
                                Spacer()
                            }
                        }
                        .overlay {
                            minTag(stockItem: stockItem)
                                .padding(.trailing, geo.size.width * 0.33)
                        }
                    }
                }
            Spacer()
            Text("\(stockItem.calculateOverflowPercentage())%")
                .font(.barGraphBarText)
        }
    }
    
    /// System to put individual stock item pieces into a single view
    /// - Parameter item: the item of stock/inventory that will be viewed
    /// - Returns: view of stock with progress bar. 
    private func generateStockItemVisual(item: StockItem) -> some View {
        let minimum = item.minimum
        let quantity = item.quantity
        
        return VStack {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(item.name)
                        .font(.bigBoldDetail)
                        .padding(.bottom, 3)
                    Text(item.description)
                        .font(.progressBarDescriptionText)
                }
                Spacer()
                overflowPill(stockItem: item)
            }
            progressBar(stockItem: item)
            HStack {
                Spacer()
                Text("\(String(format: "%.1f",quantity))/\(String(format: "%.1f",minimum)) Tons")
                    .font(.progressBarInfo)
            }
        }
        .padding(.leading, AppVariables.widgetVariables.leadingPadding)
    }
    
    var body: some View {
        ForEach(stockItems) { item in
            generateStockItemVisual(item: item)
                .padding(.bottom, 30)
        }
    }
}

#Preview {
    StockLevelsWidget(id: UUID(), stockItems: [
        StockItem(name: "RB0360", description: "Rebar Black #3 Grade 60", quantity: 80.0, minimum: 100.0),
        StockItem(name: "#5 Rebar (5/8\")", description: "Rebar Black #3 Grade 60", quantity: 120.0, minimum: 100.0),
        StockItem(name: "#4 Rebar (1/2\")", description: "Rebar Black #3 Grade 60", quantity: 230.0, minimum: 100.0),
    ]).body
}
