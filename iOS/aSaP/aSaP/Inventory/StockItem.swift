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
    
    private(set) var id: UUID = UUID()
    private(set) var name: String // Ex: #8 Rebar (1")
    private(set) var description: String
    private(set) var quantity: Double // Current inventory levels
    private(set) var minimum: Double // Minimum amount requested
    private(set) var level: InventoryLevel
    private(set) var subItems: [StockItem]?
    
    init(name: String, description: String, quantity: Double, minimum: Double, subItems: [StockItem]? = nil) {
        self.name = name
        self.description = description
        self.quantity = quantity
        self.minimum = minimum
        self.level = .warning
        self.subItems = subItems
        
        self.level = findOverflowAmount()
    }
    
    /// Simple way to determine the InventoryLevel of a given stock
    /// - Returns: InventoryLevel enum value
    func findOverflowAmount() -> InventoryLevel {
        let rawOverflow = self.quantity - self.minimum
        // raw overflow / minimum should be overflow percentage
        
        guard minimum > 0 else {
            // basic safeguard for no minimum
            return quantity > 0 ? .low : .warning
        }
        
        if rawOverflow < 0 {
            return .warning
        } else if rawOverflow / self.minimum < 0.75 {
            return .low
        }
        
        return .high
    }
    
    /// Math to determine the percentage of overflow
    /// - Returns: Int value representing the overflow amount
    func calculateOverflowPercentage() -> Int {
        guard minimum != 0 else { return 0 }
        let overflowPercentage = ((quantity - minimum) / minimum) * 100
        return Int(overflowPercentage.rounded())
    }
    
    /// Gets colors for the stock level pill
    /// - Returns: two colors, (Text Color, Background Color)
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
