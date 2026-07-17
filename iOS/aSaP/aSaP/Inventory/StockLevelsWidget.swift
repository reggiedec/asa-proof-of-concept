//
//  StockLevelsWidget.swift
//  aSaP
//
//  Created by Dalton Fitzsimmons on 7/2/26.
//

import SwiftUI

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

/// The bar of Stock items for the stock levels widget
/// - Parameter stockItem: item getting displayed
/// - Returns: a visual representation of stock level for a specific item
private func progressBar(stockItem: StockItem, barHeight: CGFloat = 12, rfCount: Int = 12, rfSpan: Int = 9) -> some View {
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
    
    
    /// Breaks width of the bar into thirds to then figure out how large it should be as a whole
    /// - Parameter width: width of the bar
    /// - Returns: Value representing total length of the item
    func mainWidth(width: CGFloat) -> CGFloat {
        var remainder = overflowPercentage
        let third = width * (1.0 / 3.0)
        var barSize: CGFloat = third
        if overflowPercentage > 100 {
            barSize += third
            remainder -= 100
        }
        
        barSize += (third * (CGFloat(remainder) / 100))
        
        return barSize
    }
    
    return HStack {
        RoundedRectangle(cornerRadius: 100)
            .fill(Color("GrayBars"))
            .padding(.vertical, barSquish) // squishes the bar
            .frame(maxHeight: barHeight)
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
            .containerRelativeFrame(.horizontal, count: rfCount, span: rfSpan, spacing: 0)
        Spacer()
        Text("\(stockItem.calculateOverflowPercentage())%")
            .font(.barGraphBarText)
    }
}

struct StockLevelsDrillDown: View {
    @Binding var showStockLevelsSheet: Bool
    @Binding var selectedStockItem: StockItem
    
    private func mainStockItem() -> some View {
        let item = selectedStockItem
        let quantity = item.quantity
        
        return VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                HStack() {
                    Text(item.name)
                        .font(.bigBoldDetail)
                        .padding(.bottom, 3)
                    Spacer()
                    overflowPill(stockItem: item)
                    Button {
                        showStockLevelsSheet = false
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 10, height: 10)
                            .foregroundStyle(.charcoalBlack)
                            .background {
                                Circle()
                                    .frame(width: 30, height: 30)
                                    .foregroundStyle(.backgroundBlack)
                            }
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 10)
                }
                Text(item.description)
                    .font(.progressBarDescriptionText)
                    .foregroundStyle(.charcoalBlack.opacity(AppVariables.widgetVariables.subHeadingOpacity))
            }
            Spacer()
            progressBar(stockItem: item)
            Text("\(quantity, format: .number.precision(.fractionLength(1))) Total Tons")
                .font(.progressBarInfo)
                .padding(.top, 26)
        }
    }
    
    private func subItem(for item: StockItem) -> some View {
        VStack {
            // Text Items
            HStack {
                Text(item.name)
                    .font(.boldeighteen)
                Spacer()
                overflowPill(stockItem: item)
            }
            
            HStack {
                Text(item.description)
                    .font(.regularFourteen)
                    .foregroundStyle(.greyText)
                Spacer()
                Text("\(item.quantity, format: .number.precision(.fractionLength(1))) Tons")
                    .font(.boldfourteen)
            }
            .padding(.top, 2)
            // bar
            progressBar(stockItem: item, rfCount: 7, rfSpan: 6)
            // To count
        }
        .padding(.vertical, 11)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            mainStockItem()
                .frame(maxHeight: 140)
            Divider()
            Text("BY SUB PRODUCT")
                .foregroundStyle(.greyText)
                .font(.semiBoldSubheader)
                .padding(.top, 7)
            
            ScrollView {
                let subItems = selectedStockItem.subItems ?? []
                ForEach(Array(subItems.enumerated()), id: \.element.id) { index, item in
                    subItem(for: item)
                    if index < subItems.count - 1 {
                        Divider()
                            .padding(.top, 10)
                    }
                }
            }
            Spacer() // push stuff to top!
        }
        .padding(.top, 30)
    }
}

// Had to make this for the sheet!
struct StockLevelsWrapper: View {
    @State private var showStockLevelsSheet: Bool = false
    @State private var selectedStockItem: StockItem = .init(name: "", description: "", quantity: 0, minimum: 0)
    private(set) var stockItems : [StockItem]
    // Need: Bar, stock item name, size pill, overflow amount, explicit count
    
    /// System to put individual stock item pieces into a single view
    /// - Parameter item: the item of stock/inventory that will be viewed
    /// - Returns: view of stock with progress bar.
    private func generateStockItemVisual(item: StockItem) -> some View {
        let minimum = item.minimum
        let quantity = item.quantity
        
        return Button {
            showStockLevelsSheet = true
            selectedStockItem = item
        } label: {
            VStack {
                VStack(alignment: .leading) {
                    HStack() {
                        Text(item.name)
                            .font(.bigBoldDetail)
                            .padding(.bottom, 3)
                        Spacer()
                        overflowPill(stockItem: item)
                    }
                    Text(item.description)
                        .font(.progressBarDescriptionText)
                        .foregroundStyle(.charcoalBlack.opacity(AppVariables.widgetVariables.subHeadingOpacity))
                }
                Spacer()
                progressBar(stockItem: item)
                HStack {
                    Spacer()
                    Text("\(String(format: "%.1f",quantity))/\(String(format: "%.1f",minimum)) Tons")
                        .font(.progressBarInfo)
                }
            }
            .padding(.leading, AppVariables.widgetVariables.leadingPadding)
        }
        .buttonStyle(.plain)
    }
    
    var body: some View {
        ForEach(Array(stockItems.enumerated()), id: \.element.id) { index, item in
            generateStockItemVisual(item: item)
                .padding(.bottom, 30)
            
            if (index < stockItems.count - 1) {
                Divider()
            }
        }
        .sheet(isPresented: $showStockLevelsSheet) {
            StockLevelsDrillDown(showStockLevelsSheet: $showStockLevelsSheet, selectedStockItem: $selectedStockItem)
                .padding(.horizontal, 22)
                .presentationDragIndicator(.visible)
        }
    }
}

struct StockLevelsWidget: WidgetProtocol {
    static func == (lhs: StockLevelsWidget, rhs: StockLevelsWidget) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: UUID
    var name: String = "Stock Levels"
    var isFavorite: Bool = false // Check if this causes issues
    private(set) var stockItems : [StockItem]
    
    var body: some View {
        StockLevelsWrapper(stockItems: stockItems)
    }
}

#Preview {
    StockLevelsWidget(id: UUID(), stockItems: [
        StockItem(name: "RB0360", description: "Rebar Black #3 Grade 60", quantity: 80.0, minimum: 100.0, subItems: [
            .init(name: "RB0360-20", description: "Rebar Black #3 Grade 60 (20-00)", quantity: 3500, minimum: 2000),
            .init(name: "RB0360-30", description: "Rebar Black #3 Grade 60 (30-00)", quantity: 28, minimum: 25),
            .init(name: "RB0360-40", description: "Rebar Black #3 Grade 60 (40-00)", quantity: 17, minimum: 25),
        ]),
        StockItem(name: "#5 Rebar (5/8\")", description: "Rebar Black #3 Grade 60", quantity: 120.0, minimum: 100.0),
        StockItem(name: "#4 Rebar (1/2\")", description: "Rebar Black #3 Grade 60", quantity: 230.0, minimum: 100.0),
    ]).body
}

