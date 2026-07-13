//
//  FinancialSummaryWidget.swift
//  aSaP
//
//  Created by Dalton Fitzsimmons on 7/13/26.
//

import SwiftUI

enum FinancialSummaryType: Int, CaseIterable {
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

struct FinancialSummaryWidget: WidgetProtocol, View {
    static func == (lhs: FinancialSummaryWidget, rhs: FinancialSummaryWidget) -> Bool {
        lhs.id == rhs.id
    }
    
    @State var selection: Int = 1 // TODO: Figure out how to get this to actually function
    
    let id: UUID
    let name: String = ""
    var isFavorite: Bool = false
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
            HStack(spacing: 4) {
                ForEach(0..<FinancialSummaryType.all.count, id: \.self) { idx in
                    let tab = FinancialSummaryType.all[idx]
                    let labelColor = selection == idx ? Color.white : Color.black
                    let backgroundView = selection == idx ? AnyView(Capsule().fill(blueFill)) : AnyView(EmptyView())
                    
                    Button {
                        selection = idx
                    } label: {
                        Text(tab.title)
                            .font(.headingThree)
                            .foregroundStyle(labelColor)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 0)
                            .frame(maxWidth: .infinity)
                            .contentShape(Capsule())
                            .background {
                                backgroundView
                            }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(4)
            .background {
                Capsule()
                    .fill(.backgroundBlack)
            }
            
            ScrollView {
                ForEach(Array(information.enumerated()), id: \.element.id) { index, info in
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

#Preview {
    FinancialSummaryWidget(id: UUID(), information: [
        .init(title: "Gross Margin", subtitle: "+2.1pts vs last month", pillInformation: .init(textInformation: "40%", pillState: .positive, colorScheme: .positive)),
        .init(title: "Gross Margin", subtitle: "+2.1pts vs last month", pillInformation: .init(textInformation: "40%", pillState: .negative, colorScheme: .negative)),
        .init(title: "Gross Margin", subtitle: "+2.1pts vs last month", pillInformation: .init(textInformation: "40%", pillState: .neutral, colorScheme: .neutral))
    ]).body
}
