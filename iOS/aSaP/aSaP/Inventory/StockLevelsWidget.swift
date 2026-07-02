//
//  StockLevelsWidget.swift
//  aSaP
//
//  Created by Dalton Fitzsimmons on 7/2/26.
//

import SwiftUI

struct StockLevelsWidget: WidgetProtocol {
    let id = UUID()
    var name: String = "Stock Levels"
    var isFavorite: Bool = false // Check if this causes issues
    private(set) var stockItems : [StockItem] = [
        StockItem(name: "#8 Rebar (1\")", quantity: 80.0, minimum: 100.0),
        StockItem(name: "#5 Rebar (5/8\")", quantity: 120.0, minimum: 100.0),
        StockItem(name: "#4 Rebar (1/2\")", quantity: 230.0, minimum: 100.0),
    ]
    
    static func == (lhs: StockLevelsWidget, rhs: StockLevelsWidget) -> Bool {
        lhs.id == rhs.id
    }
    // Need: Bar, stock item name, size pill, overflow amount, explicit count
    
    /// Creates pill for the Stock Item Levels
    /// - Parameter stockItem: a specific stock item
    /// - Returns: a view representing the level the inventory is at
    private func overflowPill(stockItem: StockItem) -> some View {
        let (textColor, backgroundColor): (Color, Color) = {
            switch stockItem.level {
            case .warning:
                return (Color("TrendTextRed"), Color("BackgroundRed"))
            case .low:
                return (Color("CharcoalBlack"), Color("BackgroundBlack"))
            case .high:
                return (Color("TrendTextGreen"), Color("BackgroundGreen"))
            }
        }()

        return Text(stockItem.level.description)
            .font(Font.custom("BeVietnamPro-SemiBold", size: 12))
            .foregroundStyle(textColor)
            .padding(.vertical, 8)
            .padding(.horizontal, 14)
            .overlay {
                RoundedRectangle(cornerRadius: 100)
                    .fill(backgroundColor)
            }
    }
    
    private func minTag() -> some View {
        return ZStack {
            Circle()
                .frame(width: 4)
            RoundedRectangle(cornerRadius: 100)
                .frame(width: 1, height: 12)
                .padding(.top, 12)
            Text("Min")
                .font(Font.custom("BeVietnamPro-SemiBold", size: 10))
                .padding(.top, 35)
        }
    }
    
    private func progressBar(stockItem: StockItem) -> some View {
        let barSquish: CGFloat = 2
        let overflowPercentage = stockItem.calculateOverflowPercentage()
        let fillRatio = min(stockItem.quantity / stockItem.minimum, 1.0)
        let mainWidth = {
            let overflow = (1.0 / 3.0) * (1 + Double(overflowPercentage) / 100.0)
            return min(1.0, overflow)
        }
        
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
        
        return HStack {
            RoundedRectangle(cornerRadius: 100)
                .fill(Color("GrayBars"))
                .padding(.vertical, barSquish) // squishes the bar
                .containerRelativeFrame(.horizontal, count: 4, span: 3, spacing: 0)
                .overlay {
                    GeometryReader { geo in
                        ZStack {
                            // stripped
                            if overflowPercentage > 0 {
                                RoundedRectangle(cornerRadius: 100)
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color(gradientStart),
                                                Color(gradientEnd),
                                                Color(gradientEnd)
                                            ],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                    .padding(.vertical, barSquish)
                                    .frame(width: geo.size.width * mainWidth())
                                    .overlay {
                                        HStack(spacing: 12) {
                                            ForEach(0..<20) {_ in
                                                Rectangle()
                                                    .fill(.white.opacity(0.3))
                                                    .frame(width: 10)
                                                    .rotationEffect(.degrees(15))
                                            }
                                        }
                                        .frame(width: geo.size.width * mainWidth())
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                    }
                            }
                            // solid color
                            HStack {
                                RoundedRectangle(cornerRadius: 100)
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color(gradientStart),
                                                Color(gradientEnd),
                                                Color(gradientEnd)
                                            ],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                    .shadow(color: .white.opacity(0.85), radius: 5)
                                    .padding(.vertical, barSquish)
                                    .frame(width: geo.size.width * (1.0 / 3.0) * fillRatio)
                                Spacer()
                            }
                        }
                        .overlay {
                            minTag()
                                .padding(.trailing, geo.size.width * 0.33)
                        }
                    }
                }
            Spacer()
            Text("\(stockItem.calculateOverflowPercentage())%")
                .font(Font.custom("BeVietnamPro-Bold", size: 13))
        }
    }
    
    private func generateStockItemVisual(item: StockItem) -> some View {
        let leadingPadding: CGFloat = 8
        let minimum = item.minimum
        let quantity = item.quantity
        
        return VStack {
            HStack {
                Text(item.name)
                    .font(Font.custom("BeVietnamPro-Bold", size: 20))
                    .padding(.leading, leadingPadding)
                Spacer()
                overflowPill(stockItem: item)
            }
            progressBar(stockItem: item)
                .padding(.leading, leadingPadding)
            HStack {
                Spacer()
                Text("\(String(format: "%.1f",quantity))/\(String(format: "%.1f",minimum)) Minimum Tons")
                    .font(Font.custom("BeVietnamPro-Bold", size: 13))
            }
        }
    }
    
    var body: some View {
        ForEach(stockItems) { item in
            generateStockItemVisual(item: item)
                .padding(.bottom, 20)
        }
    }
}

#Preview {
    StockLevelsWidget().body
}
