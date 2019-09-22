//
//  Colors.swift
//  Holk
//
//  Created by 张梦皓 on 2019-06-08.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit
enum Color {
    static func makeColor(asset name: String) -> UIColor {
        guard let color = UIColor(named: name) else {
            fatalError("No asset found with name " + name)
        }
        return color
    }
    
    static var mainBackgroundColor: UIColor {
        return makeColor(asset: #function)
    }
    
    static var secondaryBackgroundColor: UIColor {
        return makeColor(asset: #function)
    }
    
    static var placeHolderTextColor: UIColor {
        return makeColor(asset: #function)
    }
    
    static var mainForegroundColor: UIColor {
        return makeColor(asset: #function)
    }
    
    static var secondaryForegroundColor: UIColor {
        return makeColor(asset: #function)
    }
    
    static var onBoardingBackgroundColor: UIColor {
        return makeColor(asset: #function)
    }
    
    static var tabbarBackgroundColor: UIColor {
        return makeColor(asset: #function)
    }
    
    static var lightBorderColor: UIColor {
        return makeColor(asset: #function)
    }
    
    static var mainButtonBackgroundColor: UIColor {
        return makeColor(asset: #function)
    }
    
    static var mainHighlightColor: UIColor {
        return makeColor(asset: #function)
    }
}
