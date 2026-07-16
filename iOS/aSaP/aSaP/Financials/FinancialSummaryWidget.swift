//
//  FinancialSummaryWidget.swift
//  aSaP
//
//  Created by Dalton Fitzsimmons on 7/13/26.
//

import SwiftUI

enum FinancialSummaryType: Int, CaseIterable  {
    case ratios = 0
    case againg = 1
    case p_l = 2

    var title: String {
        switch self {
        case .ratios: return "Ratio"
        case .againg: return "A/R Aging"
        case .p_l: return "P&L"
        }
    }
    static var all: [FinancialSummaryType] { Array(Self.allCases) }
}

struct FinSummaryInformation: Identifiable {
    var id: UUID = UUID()
    var title: String
    var subtitle: String
    var pillInformation: FinSumPill
    let types: [FinancialSummaryType]
}

struct FinSumPill {
    var textInformation: String // info
    var pillState: PillState // Icon
    var colorScheme: PillState // Colors, not directly tied to pillState
    
    enum PillState: Comparable {
        case positive
        case negative
        case neutral
    }
    
    @ViewBuilder
    func getIcon() -> some View {
        let iconSize: CGFloat = 15
        
        switch self.pillState {
        case .positive:
            Image(systemName: "triangle.fill")
                .resizable()
                .frame(width: iconSize, height: iconSize)
                .foregroundStyle(.trendTextGreen)
        case .negative:
            Image(systemName: "triangle.fill")
                .resizable()
                .frame(width: iconSize, height: iconSize)
                .rotationEffect(Angle(degrees: 180))
                .foregroundStyle(.trendTextRed)
        case .neutral:
            Image(systemName: "minus")
                .resizable()
                .frame(width: iconSize, height: 3)
                .foregroundStyle(.charcoalBlack)
        }
    }
    
    func getColors() -> (Color, Color) {
        switch self.colorScheme {
        case .positive:
            return (.trendTextGreen, .backgroundGreen)
        case .negative:
            return (.trendTextRed, .backgroundRed)
        case .neutral:
            return (.charcoalBlack, .backgroundBlack)
        }
    }
}


/// Used because rendering WidgetProtocol does not allow for states, even doing View + WidgetProtocol does not work due to how the body is rendered (called rather than implicit). This allows for states to work
private struct FinSumWrapper: View {
    @State var selection: Int = 0
    private(set) var information: [FinSummaryInformation]
    let blueFill = LinearGradient(
        colors: [
            .blueGradient.opacity(0.7),
            .blueGradient,
            .blueGradient
        ],
        startPoint: .top,
        endPoint: .bottom
    )
    
    private func detailItem(info: FinSummaryInformation) -> some View {
        let (pillText, pillBackground) = info.pillInformation.getColors()
        
        return HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(info.title)
                    .font(.headingThree)

                Text(info.subtitle)
                    .font(.thinSubheader)
                    .foregroundStyle(.greyText)
            }
            Spacer()
            
            HStack {
                info.pillInformation.getIcon()
                
                Text(info.pillInformation.textInformation)
                    .font(.pillText)
                    .foregroundStyle(pillText)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 6)
            .background {
                Capsule()
                    .foregroundStyle(pillBackground)
            }
        }
        .padding(.vertical, 12)
    }
    
    var body: some View {
        VStack {
            
            Selector(selection: $selection, enums: FinancialSummaryType.all, label: \.title)
            
            ScrollView {
                let selectedType = FinancialSummaryType.all[selection]
                
                ForEach(Array(information.enumerated()).filter { $0.element.types.contains(selectedType) }, id: \.element.id) { index, info in
                        detailItem(info: info)
                        
                        if index < information.count - 1 {
                            Divider()
                        }
                }
            }
            .padding(.leading, AppVariables.widgetVariables.leadingPadding)
            .frame(maxHeight: 260)
        }
        
    }
}

struct FinancialSummaryWidget: WidgetProtocol {
    static func == (lhs: FinancialSummaryWidget, rhs: FinancialSummaryWidget) -> Bool {
        lhs.id == rhs.id
    }
    let id: UUID
    let name: String = "Financial Summary"
    var isFavorite: Bool = false
    private(set) var information: [FinSummaryInformation]
   
    
    var body: some View {
        FinSumWrapper(information: information)
    }
}

#Preview {
    FinancialSummaryWidget(id: UUID(), information: [
        .init(title: "Gross Margin", subtitle: "+2.1pts vs last month", pillInformation: .init(textInformation: "40%", pillState: .positive, colorScheme: .positive), types: [.againg]),
        .init(title: "Net Revenue", subtitle: "-1.3% vs last quarter", pillInformation: .init(textInformation: "$120K", pillState: .negative, colorScheme: .negative), types: [.p_l, .againg]),
        .init(title: "Debt Ratio", subtitle: "Stable", pillInformation: .init(textInformation: "1.2", pillState: .neutral, colorScheme: .neutral), types: [.ratios]),
        .init(title: "Operating Income", subtitle: "+5% YTD", pillInformation: .init(textInformation: "$50K", pillState: .positive, colorScheme: .positive), types: [.p_l])
    ]).body 
}
