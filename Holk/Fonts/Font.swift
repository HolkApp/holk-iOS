//
//  Font.swift
//  Holk
//
//  Created by 张梦皓 on 2019-06-17.
//  Copyright © 2019 Holk. All rights reserved.
//
import UIKit

public enum Font {
    enum Weight {
        case regular
        case semibold
        case bold
        case extraBold
    }
    
    public enum Size: UInt {
        
        /// 80
        case yotta = 80
        
        /// 45
        case peta = 45
        
        /// 35
        case tera = 35
        
        /// 25
        case giga = 25
        
        /// 21
        case mega = 21
        
        /// 17
        case hecto = 17
        
        /// 15
        case deci = 15
        
        /// 13
        case micro = 13
        
        /// 11
        case nano = 11
        
        /// 10
        /// - Note: This size should only be used for the tab bar label.
        case tabBarLabel = 10
        
        /// 9
        case pico = 9
        
        var pointSize: CGFloat {
            return CGFloat(rawValue)
        }
        
    }
    
    public static func regular(_ size: Size) -> UIFont {
        return font(weight: .regular, size: size)
    }
    
    public static func semibold(_ size: Size) -> UIFont {
        return font(weight: .semibold, size: size)
    }
    
    public static func bold(_ size: Size) -> UIFont {
        return font(weight: .bold, size: size)
    }
    
    private static func font(weight: Weight, size: Size) -> UIFont {
        switch weight {
        case .regular: return UIFont(name: "OpenSans-Regular", size: size.pointSize)!
        case .semibold: return UIFont(name: "Montserrat-SemiBold", size: size.pointSize)!
        case .bold: return UIFont(name: "OpenSans-Bold", size: size.pointSize)!
        case .extraBold: return UIFont(name: "Montserrat-ExtraBold", size: size.pointSize)!
        }
    }
}

