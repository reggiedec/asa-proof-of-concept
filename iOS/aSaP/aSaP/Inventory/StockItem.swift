//
//  StockItem.swift
//  aSaP
//
//  Created by Dalton Fitzsimmons on 7/2/26.
//

import Foundation
import SwiftUI

struct StockItem: Identifiable {
    enum InventoryLevel: Int, Comparable, CaseIterable {
        case warning = 0 // > +0%
        case low = 1 // +0% - +74%
        case high = 2 // +75%

        var description: String {
            switch self {
            case .warning:
                return "Below Minimum"
            case .low:
                return "Low Overflow"
            case .high:
                return "High Overflow"
            }
        }
        
        static func < (lhs: InventoryLevel, rhs: InventoryLevel) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
    }
    
    var id: UUID = UUID()
    var name: String // Ex: #8 Rebar (1")
    var quantity: Double // Current inventory levels
    var minimum: Double // Minimum amount requested
    var level: InventoryLevel
    
    init(name: String, quantity: Double, minimum: Double) {
        self.name = name
        self.quantity = quantity
        self.minimum = minimum
        self.level = .warning
        
        self.level = findOverflowAmount()
    }
    
    func findOverflowAmount() -> InventoryLevel {
        let rawOverflow = self.quantity - self.minimum
        // raw overflow / minimum should be overflow percentage
        
        if rawOverflow < 0 {
            return .warning
        } else if rawOverflow / self.minimum < 0.75 {
            return .low
        }
        
        return .high
    }
    
    func calculateOverflowPercentage() -> Int {
        let overflowPercentage = ((quantity - minimum) / minimum) * 100
        
        return Int(overflowPercentage)
    }
    
    func getLevelColors() -> (Color, Color) {
        return {
            switch level {
            case .warning:
                return (Color("TrendTextRed"), Color("BackgroundRed"))
            case .low:
                return (Color("CharcoalBlack"), Color("BackgroundBlack"))
            case .high:
                return (Color("TrendTextGreen"), Color("BackgroundGreen"))
            }
        }()
    }
    
}
