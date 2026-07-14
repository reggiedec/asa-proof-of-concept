//
//  FabDetailsWidget.swift
//  aSaP
//
//  Created by Dalton Fitzsimmons on 7/6/26.
//

import SwiftUI

struct FabDetailsWidget: WidgetProtocol {
    static func == (lhs: FabDetailsWidget, rhs: FabDetailsWidget) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: UUID
    let name: String = "Fabrication Details"
    var isFavorite: Bool = false
    var jobDetails: [JobDetail]
    private let formatter = DateFormatter()
    
    init(id: UUID, jobDetails: [JobDetail]) {
        self.id = id
        self.jobDetails = jobDetails
        formatter.locale = .current
        formatter.dateFormat = "MMM dd"
    }
    
    private func statusPill(for jobDetail: JobDetail) -> some View {
        return Group {
                if let icon = jobDetail.status.pillIcon {
                    HStack {
                        icon
                        Text(jobDetail.status.pillDescription)
                    }
                } else {
                    Text(jobDetail.status.pillDescription)
                }
            }
            .font(Font.custom("BeVietnamPro-SemiBold", size: 12))
            .foregroundStyle(jobDetail.status.pillTextColor)
            .padding(.vertical, 8)
            .padding(.horizontal, 14)
            .background {
                RoundedRectangle(cornerRadius: 100)
                    .fill(jobDetail.status.pillBackgroundColor)
            }
    }
    
    private func individualJobDetail(for jobDetail: JobDetail) -> some View {
        let barCornerRadius: CGFloat = 100
        let barMaxHeight: CGFloat = 12
        let percetComplete = jobDetail.ordersTotal == 0 ? 0 : (Double(jobDetail.ordersCompleted) / Double(jobDetail.ordersTotal)) * 100
        
        return VStack {
            // item header
            HStack {
                Text(jobDetail.name)
                    .font(.bigBoldDetail)
                    .frame(alignment: .leading)

                Spacer()
                statusPill(for: jobDetail)
            }
            // Company details, date
            HStack(alignment: .center) {
                VStack (alignment: .leading){ // Looks really off.
                    Text(jobDetail.location)
                        .font(.semiBoldSubheader) // Made it larger to hopefully help sizing issues
                        .lineLimit(1)

                    Text(jobDetail.company)
                        .font(.thinSubheader)
                        .lineLimit(1)
                }
                Spacer()
                Text("Due \(jobDetail.dueDate)")
                    .font(.semiBoldSubheader)
                    .padding(.trailing, 10)
            }
            // progress bar
            HStack{
                GeometryReader { geo in
                    let barSize = max(0, geo.size.width - 10)
                    
                    ZStack(alignment: .leading) {
                        GenericBar(
                            cornerRadius: barCornerRadius,
                            barFill: .grayBars,
                            barHeight: barMaxHeight,
                            fillRatio: barSize  // is all remaining space - padding
                        )
                        
                        GenericBar(
                            cornerRadius: barCornerRadius,
                            barFill: jobDetail.status.barGradientColor,
                            barHeight: barMaxHeight,
                            fillRatio: barSize * (percetComplete / 100)
                        )
                    }

                }
                Spacer()
                Text("\(percetComplete, specifier: "%.0f")%")
                    .font(.progressTiny)
            }
            // Specific details
            HStack {
                Text("\(jobDetail.ordersCompleted)/\(jobDetail.ordersTotal) orders")
                    .font(.progressBarInfo)
                Spacer()
                Text("\(jobDetail.amountCompleted, specifier: "%.1f")/\(jobDetail.amountTotal, specifier: "%.1f") T")
                    .font(.progressBarInfo)
            }
        }
    }
    
    var body: some View {
        let sortedJobs = jobDetails.sorted { lhs, rhs in
            lhs.status < rhs.status
        }
        return ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(Array(sortedJobs.enumerated()), id: \.element.id) { index, job in
                    individualJobDetail(for: job)
                        .padding(.vertical, 8)
                    
                    if (index < sortedJobs.count - 1) {
                            Divider()
                    }
                }
            }
        }
        .padding(.leading, AppVariables.widgetVariables.leadingPadding)
    }
}

#Preview {
    FabDetailsWidget(id: UUID(), jobDetails: [
        JobDetail(
            name: "J-2245",
            status: .atRisk,
            dueDate: "Jun 14",
            location: "Middletown Parking GarageSmal",
            company: "Valley Structures",
            amountCompleted: 34.2,
            amountTotal: 84.2,
            ordersCompleted: 9,
            ordersTotal: 22
        ),
        JobDetail(
            name: "J-2233",
            status: .onTrack,
            dueDate: "Jun 12",
            location: "Small",
            company: "Really long smaller text to see contrast",
            amountCompleted: 30.0,
            amountTotal: 60.0,
            ordersCompleted: 15,
            ordersTotal: 30
        ),
        JobDetail(
            name: "J-2241",
            status: .scheduled,
            dueDate: "Jun 19",
            location: "Really long main text to check length amount",
            company: "Checking how overflow looks on the smaller bottom bar",
            amountCompleted: 0.0,
            amountTotal: 40.0,
            ordersCompleted: 0,
            ordersTotal: 10
        ),
        JobDetail(
            name: "J-2251",
            status: .completed,
            dueDate: "Jun 07",
            location: "Longer Main Text but not too long",
            company: "small",
            amountCompleted: 100.0,
            amountTotal: 100.0,
            ordersCompleted: 25,
            ordersTotal: 25
        )
    ]).body
}
