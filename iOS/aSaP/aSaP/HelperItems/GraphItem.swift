//
//  GraphBar.swift
//  aSaP
//
//  Created by Dalton Fitzsimmons on 7/7/26.
//

import SwiftUI

struct GraphItem: Identifiable {
    private(set) var id: UUID = UUID()
    private(set) var name: String
    private(set) var value: Double
    private(set) var fill: AnyShapeStyle
    
    init(id: UUID = UUID(), name: String, value: Double, fill: AnyShapeStyle) {
        self.id = id
        self.name = name
        self.value = value
        self.fill = fill
    }

    // Convenience initializer that erases ShapeStyle
    init(id: UUID = UUID(), name: String, value: Double, fill: some ShapeStyle) {
        self.init(id: id, name: name, value: value, fill: AnyShapeStyle(fill))
    }
}
