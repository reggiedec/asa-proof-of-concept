//
//  Selector.swift
//  aSaP
//
//  Created by Dalton Fitzsimmons on 7/14/26.
//

import SwiftUI

struct Selector<T: CaseIterable & RawRepresentable & Equatable>: View where T.RawValue: Equatable {
    @Binding var selection: Int
    let enums: [T]
    let label: (T) -> String

    private var labels: [String] {
        enums.map(label)
    }

    private let blueFill = LinearGradient(
        colors: [
            .blueGradient.opacity(0.7),
            .blueGradient,
            .blueGradient
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    var body: some View {
        HStack(spacing: 4) {
            ForEach(Array(labels.enumerated()), id: \.0) { idx, text in
                let isSelected = selection == idx
                let labelColor = isSelected ? Color.white : Color.black
                let backgroundView = isSelected ? AnyView(Capsule().fill(blueFill)) : AnyView(EmptyView())

                Button {
                    selection = idx
                } label: {
                    Text(text)
                        .font(.headingThree)
                        .foregroundStyle(labelColor)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 0)
                        .frame(maxWidth: .infinity)
                        .contentShape(Capsule())
                        .background { backgroundView }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background {
            Capsule()
                .fill(.backgroundBlack)
        }
    }
}
