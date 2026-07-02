//
//  SwiftUIView.swift
//  aSaP
//
//  Created by Dalton Fitzsimmons on 7/1/26.
//

import SwiftUI

struct FavoriteGuideWidget: View {
    @Binding var selectedTab: Int
    @Binding var favoriteGuide: Bool
    
    private let horizontalContentPadding: CGFloat = 40
    private let horizontalPadding: CGFloat = 20
    private let verticalPadding: CGFloat = 12
    
    var body: some View {
        VStack {
            Spacer()
            Text("No Widgets Favorited")
                .font(Font.custom("BeVietnamPro-Regular", size: 20))
            Spacer()
            Text("Favorite some widgets to customize your home page")
                .font(Font.custom("BeVietnamPro-Regular", size: 14))
                .multilineTextAlignment(.center)
            Spacer()
            Button {
                selectedTab = 1
                favoriteGuide = true
            } label: {
               Text("Add Widgets")
                    .font(Font.custom("BeVietnamPro-Regular", size: 12))
                    .foregroundColor(.white)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .background {
                        RoundedRectangle(cornerRadius: 100)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color("BlueGradient").opacity(0.7),
                                        Color("BlueGradient"),
                                        Color("BlueGradient")
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    }
            }
            Spacer()
        }
        .padding(.horizontal, horizontalContentPadding)
        .frame(maxWidth: .infinity)
        .containerRelativeFrame(.vertical, count: 10, span: 3, spacing: 0)
        .background {
            RoundedRectangle(cornerRadius: 24)
                .foregroundStyle(.white)
        }
        .padding(.horizontal, horizontalPadding)
    }
}

#Preview {
    FavoriteGuideWidget(selectedTab: Binding<Int>.constant(0), favoriteGuide: Binding<Bool>.constant(false))
}
