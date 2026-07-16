//
//  EstimatesWidget.swift
//  aSaP
//
//  Created by Dalton Fitzsimmons on 7/9/26.
//

import SwiftUI

struct EstimateInformation: Identifiable {
    private(set) var id: UUID = UUID()
    private(set) var estimateName: String
    private(set) var companyName: String
    private(set) var date: String
    private(set) var weight: Double
    private(set) var value: Double
    private(set) var estimateStatus: EstimateStatus
    
    enum EstimateStatus: Int, Comparable {
        case lost = 0
        case open = 1
        case submitted = 2
        case won = 3
        
        static func < (lhs: EstimateInformation.EstimateStatus, rhs: EstimateInformation.EstimateStatus) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
        
        func pillDescription() -> String {
            switch self {
            case .lost:
                return "Lost"
            case .open:
                return "Open"
            case .submitted:
                return "Submitted"
            case .won:
                return "Won"
            }
        }
        
        func getLevelColors() -> (Color, Color) {
            return {
                switch self {
                case .lost:
                    return (Color("TrendTextRed"), Color("BackgroundRed"))
                case .open:
                    return (Color("CharcoalBlack"), Color("BackgroundBlack"))
                case .submitted:
                    return (.blueGradient, .blueGradient.opacity(0.1))
                case .won:
                    return (Color("TrendTextGreen"), Color("BackgroundGreen"))
                }
            }()
        }
    }
}

struct EstimatesWidget: WidgetProtocol {
    static func == (lhs: EstimatesWidget, rhs: EstimatesWidget) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: UUID
    let name: String = "Estimates"
    var isFavorite: Bool = false
    private(set) var estimates: [EstimateInformation]
    private let maxScrollHeight: CGFloat = 300
    
    private func generatePill(estimate: EstimateInformation.EstimateStatus) -> some View {
        let (textColor, backgroundColor) = estimate.getLevelColors()
        let horizontalPadding: CGFloat = 11
        let verticalPadding: CGFloat = 3
        
        return Text(estimate.pillDescription())
            .font(.pillText)
            .foregroundStyle(textColor)
            .padding(EdgeInsets(top: verticalPadding, leading: horizontalPadding, bottom: verticalPadding, trailing: horizontalPadding))
            .background {
                RoundedRectangle(cornerRadius: 100)
                    .fill(backgroundColor)
            }
    }
    
    private func estimateContent(estimate: EstimateInformation) -> some View {
        let informationSpacing: CGFloat = 4
        let subInfoSpacing: CGFloat = 3
        
        return HStack {
            // MARK: Information
            VStack(alignment: .leading, spacing: informationSpacing) {
                // Main Text
                Text(estimate.estimateName)
                    .font(.headingThree)
                    .lineLimit(1)
                // Company Name + Estimate Information
                VStack(alignment: .leading, spacing: subInfoSpacing) {
                    Text(estimate.companyName)
                        .font(.subHeader)
                        .lineLimit(1)
                        .foregroundStyle(.opacity(AppVariables.widgetVariables.subHeadingOpacity)) // Cannot apply to the font style, needs to be done on Text items individually
                    
                    Text("\(estimate.weight.formatted(.number.precision(.fractionLength(1)))) Tons | \(estimate.value.formatted(.currency(code: "USD")))")
                        .font(.subHeader)
                        .lineLimit(1)
                        .foregroundStyle(.opacity(AppVariables.widgetVariables.subHeadingOpacity))
                }
            }
            .padding(.leading, AppVariables.widgetVariables.leadingPadding)
            
            Spacer()
            
            // MARK: Pill and Date
            VStack(alignment: .trailing) {
                generatePill(estimate: estimate.estimateStatus)
                
                Spacer()
                
                Text(estimate.date)
                    .font(.subHeader)
                    .lineLimit(1)
                    .foregroundStyle(.opacity(0.7))
                    .padding(.trailing, AppVariables.widgetVariables.leadingPadding) // works well!
            }
        }
    }
    
    var body: some View {
        ScrollView { // Should allow for scrolling once __ limit is reached on VStack Height
            ForEach(Array(estimates.enumerated()), id: \.element.id) { index, estimate in
                estimateContent(estimate: estimate)
                    .padding(.bottom, 12)
                    .padding(.top, 6)
                if index < estimates.count - 1 {
                    Divider()
                }
            }
        }
        .frame(maxHeight: maxScrollHeight)
    }
}

#Preview {
    EstimatesWidget(id: UUID(), estimates: [
        .init(estimateName: "Estimate Name", companyName: "Company Name", date: "Date", weight: 1_000_000, value: 1_000_000, estimateStatus: .won)
    ]).body
}
