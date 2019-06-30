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
        case light
        case regular
        case semibold
        case bold
        case extraBold
    }
    
    public enum Size: UInt {
        /// 35
        case header = 35
        
        /// 30
        case secondHeader = 30
        
        /// 27
        case title = 27
        
        /// 25
        case cellTitle = 25
        
        /// 19
        case subtitle = 19
        
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
    
    public static func light(_ size: Size) -> UIFont {
        return font(weight: .light, size: size)
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
    
    public static func extraBold(_ size: Size) -> UIFont {
        return font(weight: .extraBold, size: size)
    }
    
    private static func font(weight: Weight, size: Size) -> UIFont {
        switch weight {
        case .light: return UIFont(name: "Montserrat-Regular", size: size.pointSize)!
        case .regular: return UIFont(name: "OpenSans-Regular", size: size.pointSize)!
        case .semibold: return UIFont(name: "Montserrat-SemiBold", size: size.pointSize)!
        case .bold: return UIFont(name: "OpenSans-Bold", size: size.pointSize)!
        case .extraBold: return UIFont(name: "Montserrat-ExtraBold", size: size.pointSize)!
        }
    }
}

