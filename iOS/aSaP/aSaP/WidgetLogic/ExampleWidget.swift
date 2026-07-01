//
//  EmptyWidget.swift
//  aSaP
//
//  Created by Dalton Fitzsimmons on 6/30/26.
//

import SwiftUI


/// Example Widget, follow basic guide when making different widgets
struct ExampleWidget: WidgetProtocol {
    let id = UUID()
    var name: String
    var isFavorite: Bool
    
    var body: some View {
        VStack {
            Text("\(name)")
                .frame(maxWidth: .infinity, alignment: .center)
                .font(Font.custom("BeVietnamPro-Regular", size: 18))
        }
    }
}

#Preview {
    ExampleWidget(name: "testName", isFavorite: false).body
}
