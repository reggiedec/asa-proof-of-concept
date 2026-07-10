//
//  NotificationPage.swift
//  aSaP
//
//  Created by Dalton Fitzsimmons on 7/10/26.
//

import SwiftUI

struct NotificationPage: View {
    var initalFilter: String
    // UI Variables
    private let headerImageSize: CGFloat = 17
    private let headerImageBackgroundSize: CGFloat = 36
    
    init(initalFilter: String) {
        self.initalFilter = initalFilter
    }
    
    var body: some View {
        VStack {
            // Header
            HStack {
                Button {
                    
                } label: {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .foregroundStyle(.lightBlack)
                        .frame(width: headerImageSize, height: headerImageSize)
                        .background {
                            Circle()
                                .frame(width: headerImageBackgroundSize, height: headerImageBackgroundSize)
                                .foregroundStyle(.backgroundBlack)
                        }
                }
                .buttonStyle(.plain)
                
                Spacer()
                
                Text("Notifications")
                    .font(.headingThree)
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "slider.horizontal.3")
                        .resizable()
                        .frame(width: headerImageSize, height: headerImageSize)
                        .foregroundStyle(.charcoalBlack)
                        .background {
                            Circle()
                                .frame(width: headerImageBackgroundSize, height: headerImageBackgroundSize)
                                .foregroundStyle(.backgroundBlack)
                        }
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 20)
            
            ScrollView {
                
            }
        }
    }
}

#Preview {
    NotificationPage(initalFilter: AppVariables.PageKeys.home)
}
