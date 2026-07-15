//
//  FabDetail.swift
//  aSaP
//
//  Created by Dalton Fitzsimmons on 7/6/26.
//

import Foundation
import SwiftUI

struct FabDetail: Identifiable {
    let id: UUID = UUID()
    private(set) var name: String
    private(set) var dueDate: String
    private(set) var location: String
    private(set) var company: String
    private(set) var subItems: [DetailSubItem]
}

struct DetailSubItem {
    private(set) var amount: Double
    private(set) var jobType: JobType
}

enum JobType: Int, CaseIterable {
    case open = 0
    case fabricated = 1
    case shipped = 2
    case remaining = 3
    
    var title: String {
        switch self {
        case .open:
            return "Open"
        case .fabricated:
            return "Fabricated"
        case .shipped:
            return "Shipped"
        case .remaining:
            return "Remaining"
        }
    }
    static var all: [JobType] { Array(Self.allCases) }
}
