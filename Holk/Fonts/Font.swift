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
        case hugeHeader = 50
        
        /// 40
        case header = 40
        
        /// 30
        case subHeader = 30
        
        /// 27
        case title = 27
        
        /// 21
        case caption = 21
        
        /// 19
        case cellTitle = 19
        
        /// 17
        case subtitle = 17
        
        /// 14
        case description = 14
        
        /// 12
        case label = 12
        
        /// 10
        case tabBarLabel = 10
        
        /// 9
        case pico = 9
        
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
        return font(weight: .semibold, size: size)
    }
    
    static func extraBold(_ size: Size) -> UIFont {
        return font(weight: .extraBold, size: size)
    }
    
    private static func font(weight: Weight, size: Size) -> UIFont {
        switch weight {
        case .light: return UIFont(name: "Montserrat-Regular", size: size.pointSize)!
        case .regular: return UIFont(name: "OpenSans-Regular", size: size.pointSize)!
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
    /// 22
    static let smallIconSize = CGSize.init(width: 22, height: 22)
    /// 30
    static let tabBarIconSize = CGSize.init(width: 30, height: 30)
    /// 45
    static let mediumIconSize = CGSize.init(width: 45, height: 45)
    /// 53
    static let largeIconSize = CGSize.init(width: 53, height: 53)
}
