//
//  Font.swift
//  Holk
//
//  Created by 张梦皓 on 2019-06-17.
//  Copyright © 2019 Holk. All rights reserved.
//
import UIKit

enum Font {
    enum Weight {
        case light
        case regular
        case semibold
        case bold
        case extraBold
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
    
    static func light(_ size: Size) -> UIFont {
        return font(weight: .light, size: size)
    }
    
    static func regular(_ size: Size) -> UIFont {
        return font(weight: .regular, size: size)
    }
    
    static func semibold(_ size: Size) -> UIFont {
        return font(weight: .semibold, size: size)
    }
    
    static func bold(_ size: Size) -> UIFont {
        return font(weight: .bold, size: size)
    }
    
    static func extraBold(_ size: Size) -> UIFont {
        return font(weight: .extraBold, size: size)
    }
    
    private static func font(weight: Weight, size: Size) -> UIFont {
        switch weight {
        case .light: return UIFont(name: "Montserrat-Regular", size: size.pointSize)!
        case .regular: return UIFont(name: "Poppins-Regular", size: size.pointSize)!
        case .semibold: return UIFont(name: "Poppins-SemiBold", size: size.pointSize)!
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
    /// 30
    static let tabBarIconSize = CGSize.init(width: 30, height: 30)
    /// 45
    static let mediumIconSize = CGSize.init(width: 45, height: 45)
    /// 50
    static let largeIconSize = CGSize.init(width: 55, height: 55)
}
