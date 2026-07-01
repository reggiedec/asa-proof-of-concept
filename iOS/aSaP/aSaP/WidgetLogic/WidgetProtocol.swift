//
//  WidgitProtocol.swift
//  aSaP
//
//  Created by Dalton Fitzsimmons on 6/30/26.
//

import SwiftUI

/// Protocol for all Widgets
/// Identifiable: Ensure all items have a unique ID
/// Equatable: Allows stuff like this == that, or removeAll(where: )
protocol WidgetProtocol: Identifiable, Equatable {
    var id: UUID { get }
    var name: String { get }
    var isFavorite: Bool { get set }
    
    associatedtype Body: View
    @ViewBuilder var body: Body { get }
}
