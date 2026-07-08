//
//  FabDetail.swift
//  aSaP
//
//  Created by Dalton Fitzsimmons on 7/6/26.
//

import Foundation
import SwiftUI

struct JobDetail: Identifiable  {
    let id: UUID = UUID()
    private(set) var name: String
    private(set) var status: JobStatus // determined by aSa
    private(set) var dueDate: String // check if should be date or string, assuming date for comparisons
    private(set) var location: String
    private(set) var company: String
    private(set) var amountCompleted: Double
    private(set) var amountTotal: Double
    private(set) var ordersCompleted: Int
    private(set) var ordersTotal: Int
    
    
    enum JobStatus: Int, Comparable {
        // TODO: Check if this actually sorts by atRisk -> completed
        static func < (lhs: JobDetail.JobStatus, rhs: JobDetail.JobStatus) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
        // should this be public?
        case atRisk = 0
        case onTrack = 1
        case scheduled = 2
        case completed = 3
        
        var pillDescription: String {
            switch self {
            case .atRisk:
                return "At Risk"
            case .onTrack:
                return "On Track"
            case .scheduled:
                return "Scheduled"
            case .completed:
                return "Completed"
            }
        }
        
        var pillIcon: Image? {
            // only have image for at risk
            switch self {
            case .atRisk:
                return Image(systemName: "exclamationmark.triangle")
            default:
                return nil
            }
        }
        
        var pillTextColor: Color {
            switch self {
            case .atRisk:
                return Color("TrendTextRed")
            case .onTrack:
                return Color("BlueGradient")
            case .scheduled:
                return Color("CharcoalBlack")
            case .completed:
                return Color("TrendTextGreen")
            }
        }
        
        var pillBackgroundColor: Color {
            switch self {
            case .atRisk:
                return Color("BackgroundRed")
            case .onTrack:
                return Color("BlueGradient").opacity(0.10)
            case .scheduled:
                return Color("BackgroundBlack")
            case .completed:
                return Color("BackgroundGreen")
            }
        }
        
        var barGradientColor: LinearGradient {
            var gradientStart: Color
            var gradientEnd: Color
            
            switch self {
            case .atRisk:
                gradientStart = .gradientRedStart
                gradientEnd = .gradientRedEnd
            case .onTrack:
                gradientStart = .blueGradient.opacity(0.7)
                gradientEnd = .blueGradient
            case .scheduled:
                gradientStart = .grayBars
                gradientEnd = .grayBars
            case .completed:
                gradientStart = .gradientGreenStart
                gradientEnd = .gradientGreenEnd
            }
            
            return LinearGradient(
                colors: [
                    Color(gradientStart),
                    Color(gradientEnd),
                    Color(gradientEnd)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
}
