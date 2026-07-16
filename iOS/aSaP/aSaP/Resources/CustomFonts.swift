//
//  CustomFonts.swift
//  aSaP
//
//  Created by Dalton Fitzsimmons on 7/8/26.
//

import SwiftUI

extension Font {
    static func beVietnam(_ style: BeVietnamStyle, size: CGFloat) -> Font {
        Font.custom(style.rawValue, size: size)
    }
    
    enum BeVietnamStyle: String {
        case black = "BeVietnamPro-Black"
        case blackItalic = "BeVietnamPro-BlackItalic"
        case bold = "BeVietnamPro-Bold"
        case boldItalic = "BeVietnamPro-BoldItalic"
        case extraBold = "BeVietnamPro-ExtraBold"
        case extraBoldItalic = "BeVietnamPro-ExtraBoldItalic"
        case light = "BeVietnamPro-Light"
        case extraLight = "BeVietnamPro-ExtraLight"
        case extraLightItalic = "BeVietnamPro-ExtraLightItalic"
        case italic = "BeVietnamPro-Italic"
        case medium = "BeVietnamPro-Medium"
        case mediumItalic = "BeVietnamPro-MediumItalic"
        case regular = "BeVietnamPro-Regular"
        case semiBold = "BeVietnamPro-SemiBold"
        case semiBoldItalic = "BeVietnamPro-SemiBoldItalic"
        case thin = "BeVietnamPro-Thin"
        case thinItalic = "BeVietnamPro-ThinItalic"
    }
    
    static let progressTiny: Font = .beVietnam(.semiBold, size: 12)
    static let headingTwo: Font = .beVietnam(.regular, size: 20)
    static let headingThree: Font = .beVietnam(.medium, size: 16)
    static let subHeader: Font = .beVietnam(.regular, size: 12)
    static let toggleTex: Font = .beVietnam(.semiBold, size: 13)
    static let pillText: Font = .beVietnam(.semiBold, size: 15)
    static let notificationBody: Font = .beVietnam(.regular, size: 10)
    static let notificationHeaderText: Font = .beVietnam(.semiBold, size: 11)
    static let alertBodySmaller: Font = .beVietnam(.regular, size: 12)
    static let bigNumber: Font = .beVietnam(.bold, size: 38)
    static let barGraphBarText: Font = .beVietnam(.semiBold, size: 12)
    static let barGraphTons: Font = .beVietnam(.semiBold, size: 10)
    static let progressBarInfo: Font = .beVietnam(.bold, size: 14)
    static let bigBoldDetail:Font = .beVietnam(.bold, size: 20)
    static let thinSubheader:Font = .beVietnam(.regular, size: 12)
    static let semiBoldSubheader:Font = .beVietnam(.semiBold, size: 12)
    static let tinyPillText:Font = .beVietnam(.semiBold, size: 14)
    static let progressBarDescriptionText:Font = .beVietnam(.regular, size: 16)
    static let regularFourteen:Font = .beVietnam(.regular, size: 14)
    static let boldTwenty: Font = .beVietnam(.bold, size: 20)
}
