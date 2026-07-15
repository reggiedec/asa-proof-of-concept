//
//  FabDetailsWidget.swift
//  aSaP
//
//  Created by Dalton Fitzsimmons on 7/6/26.
//

import SwiftUI

struct FabDetailWrapper: View {
    @State var selection: Int = 0
    var jobDetails: [FabDetail]
    
    private var selectedJobType: JobType {
        JobType.all[selection]
    }
    
    private func totalAmount(for item: FabDetail) -> Double {
        item.subItems.reduce(0) { $0 + $1.amount }
    }
    
    private func subItemPercentages(for item: FabDetail, total: Double) -> (Double, Double, Double) {
        let openAmount = item.subItems.first(where: { $0.jobType == .open })?.amount ?? 0
        let fabAmount = item.subItems.first(where: { $0.jobType == .fabricated })?.amount ?? 0
        let shipAmount = item.subItems.first(where: { $0.jobType == .shipped })?.amount ?? 0
        
        return (openAmount / total, fabAmount / total, shipAmount / total)
    }
    
    private func detailItem(for item: FabDetail, jobType: JobType) -> some View {
        let subItem = item.subItems.first { $0.jobType == jobType }
        let amount = totalAmount(for: item)
        let (openRatio, fabRatio, shipRatio) = subItemPercentages(for: item, total: amount) // remaining always takes up remaining space
        let barRadius: CGFloat = 32
        let barHeight: CGFloat = 16
        let blueGradient = LinearGradient(
            colors: [
                .blueGradient.opacity(0.7),
                .blueGradient,
                .blueGradient
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        let greenGradient = LinearGradient(
            colors: [
                .gradientGreenStart,
                .gradientGreenEnd,
                .gradientGreenEnd
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        let grayGradient = LinearGradient(
            colors: [
                .charcoalBlack.opacity(0.7),
                .charcoalBlack,
                .charcoalBlack
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        let fakeGradient = LinearGradient(
            colors: [
                .grayBars,
                .grayBars,
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        
        return VStack(alignment: .leading) {
            HStack {
                Text(item.name)
                    .font(.bigBoldDetail)
                    .padding(.bottom, 2)
                Spacer()
                Text("Due \(item.dueDate)")
                    .font(.semiBoldSubheader)
            }
            VStack(alignment: .leading) {
                Text(item.location)
                    .font(.progressBarInfo)
                Text(item.company)
                    .font(.thinSubheader)
                    .foregroundStyle(.greyText)
            }
            
            // Bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    // Remaining
                    GenericBar(cornerRadius: barRadius, barFill: jobType == JobType.remaining ? grayGradient : fakeGradient, barHeight: barHeight, fillRatio: geo.size.width)
                        .frame(height: barHeight) // some reason this helps fix sizing issues?
                        .overlay {
                            HStack(spacing: 12) {
                                ForEach(0..<20) {_ in
                                    Rectangle()
                                        .fill(jobType == JobType.remaining ? .white.opacity(0.3) : .clear)
                                        .frame(width: 10, height: barHeight + 2) // added height to fix gap at top and bottom
                                        .rotationEffect(.degrees(15))
                                }
                            }
                            .frame(width: geo.size.width)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                    // shipped
                    GenericBar(cornerRadius: barRadius, barFill: jobType == JobType.shipped ? greenGradient : fakeGradient, barHeight: barHeight, fillRatio: (geo.size.width * openRatio) + (geo.size.width * fabRatio) + (geo.size.width * shipRatio))
                        .frame(height: barHeight)
                    // fabricated
                    GenericBar(cornerRadius: barRadius, barFill: jobType == JobType.fabricated ? blueGradient : fakeGradient, barHeight: barHeight, fillRatio: (geo.size.width * openRatio) + (geo.size.width * fabRatio))
                        .frame(height: barHeight)
                    // Open
                    GenericBar(cornerRadius: barRadius, barFill: jobType == JobType.open ? grayGradient : fakeGradient, barHeight: barHeight, fillRatio: geo.size.width * openRatio)
                        .frame(height: barHeight)
                }
            }
            .padding(.bottom, 12)
            
            // Weights
            HStack {
                VStack(alignment: .leading) {
                    if let subItem {
                        Text(subItem.jobType.title.uppercased())
                            .font(.semiBoldSubheader)
                            .foregroundStyle(.greyText)
                        Text(subItem.amount, format: .number.precision(.fractionLength(2)))
                            .font(.progressBarInfo)
                    }
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("TOTAL")
                        .font(.semiBoldSubheader)
                        .foregroundStyle(.greyText)
                    Text(amount, format: .number.precision(.fractionLength(2)))
                        .font(.progressBarInfo)
                    
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            Selector(selection: $selection, enums: JobType.all, label: \.title, fontSize: .toggleTex)
            
            ScrollView {
                ForEach(Array(jobDetails.enumerated()).filter { $0.element.subItems.contains(where: { $0.jobType == selectedJobType }) }, id: \.element.id) { index, job in
                    detailItem(for: job, jobType: selectedJobType)
                }
            }
            .padding(.leading, AppVariables.widgetVariables.leadingPadding)
        }
    }
}

struct FabDetailsWidget: WidgetProtocol {
    static func == (lhs: FabDetailsWidget, rhs: FabDetailsWidget) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: UUID
    let name: String = "Fabrication Details"
    var isFavorite: Bool = false
    var jobDetails: [FabDetail]

   
    var body: some View {
        FabDetailWrapper(jobDetails: jobDetails)
    }
}

#Preview {
    FabDetailsWidget(id: UUID(), jobDetails: [
        .init(name: "J-2241", dueDate: "Jun 12", location: "Riverfront Tower - Pkg A", company: "Cornerstone Builders", subItems: [
            .init(amount: 68_400, jobType: .open),
            .init(amount: 10_000, jobType: .fabricated),
            .init(amount: 20_000, jobType: .shipped),
            .init(amount: 60_000, jobType: .remaining)
        ])
    ]).body
}
