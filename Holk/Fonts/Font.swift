//
//  Font.swift
//  Holk
//
//  Created by 张梦皓 on 2019-06-17.
//  Copyright © 2019 Holk. All rights reserved.
//
import UIKit

enum Font {
    enum Name: CustomStringConvertible {
        case montserrat
        case poppins
        case raleway
        case lato

        var description: String {
            switch self {
            case .montserrat:
                return "Montserrat"
            case .poppins:
                return "Poppins"
            case .raleway:
                return "Raleway"
            case .lato:
                return "Lato"
            }
        }
    }

    enum Weight: CustomStringConvertible {
        case light
        case regular
        case medium
        case semiBold
        case bold
        case extraBold

        var description: String {
            switch self {
            case .light: return "Light"
            case .regular: return "Regular"
            case .medium: return "Medium"
            case .semiBold: return "SemiBold"
            case .bold: return "Bold"
            case .extraBold: return "ExtraBold"
            }
        }
    }
    
    enum Size: UInt {
        /// 50
        case promptHeader = 50
        
        /// 45
        case header = 45
        
        /// 39
        case subHeader = 39

        /// 30
        case sectonHeader = 30
        
        /// 25
        case title = 25
        
        /// 20
        case label = 20
        
        /// 17
        case subtitle = 17
        
        /// 13
        case description = 13
        
        /// 10
        case tabBarLabel = 10
        
        /// 9
        case micro = 9
        
        var pointSize: CGFloat {
            return CGFloat(rawValue)
        }
    }

    static func font(name: Name, weight: Weight, size: CGFloat) -> UIFont {
        return UIFont(name: "\(name.description)-\(weight.description)", size: size)!
    }

    @available(*, deprecated)
    static func regular(_ size: Size) -> UIFont {
        return font(weight: .regular, size: size)
    }

    @available(*, deprecated)
    static func medium(_ size: Size) -> UIFont {
        return font(weight: .medium, size: size)
    }

    @available(*, deprecated)
    static func semiBold(_ size: Size) -> UIFont {
        return font(weight: .semiBold, size: size)
    }

    @available(*, deprecated)
    static func bold(_ size: Size) -> UIFont {
        return font(weight: .bold, size: size)
    }

    @available(*, deprecated)
    static func extraBold(_ size: Size) -> UIFont {
        return font(weight: .extraBold, size: size)
    }

    // TODO: Remove this
    private static func font(weight: Weight, size: Size) -> UIFont {
        switch weight {
        case .light: return UIFont(name: "Poppins-Light", size: size.pointSize)!
        case .regular: return UIFont(name: "Montserrat-Regular", size: size.pointSize)!
        case .medium: return UIFont(name: "Poppins-Medium", size: size.pointSize)!
        case .semiBold: return UIFont(name: "Poppins-SemiBold", size: size.pointSize)!
        case .bold: return UIFont(name: "Montserrat-Bold", size: size.pointSize)!
        case .extraBold: return UIFont(name: "Montserrat-ExtraBold", size: size.pointSize)!
        }
    }
}

extension Font {
    static func fontAwesome(style: FontAwesomeStyle, size: Size) -> UIFont {
        UIFont.loadFontAwesome(ofStyle: style)
        return UIFont.fontAwesome(ofSize: size.pointSize, style: style)
    }
}

extension FontAwesome {
    /// 45
    static let mediumIconSize = CGSize.init(width: 45, height: 45)
}
