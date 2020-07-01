//
//  Colors.swift
//  Holk
//
//  Created by 张梦皓 on 2019-06-08.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit
enum Color {

    enum ColorProvider: String {
        case blue1
        case blue2
        case blue3
        case blue5
        case blue8
        case green1
        case grey1
        case pink1
        case red1
        case yellow2
    }

    static func makeColor(asset name: ColorProvider) -> UIColor {
        guard let color = UIColor(named: name.rawValue) else {
            fatalError("No asset found with name " + name.rawValue)
        }
        return color
    }

    static func makeColor(asset name: String) -> UIColor {
        guard let color = UIColor(named: name) else {
            fatalError("No asset found with name " + name)
        }
        return color
    }
    
    static var landingBackgroundColor: UIColor {
        return makeColor(asset: #function)
    }
    
    static var landingSecondaryBackgroundColor: UIColor {
        return makeColor(asset: #function)
    }

    static var suggestionCardBackgroundColor: UIColor {
        return makeColor(asset: #function)
    }

    static var suggestionCardPressDownBackgroundColor: UIColor {
        return makeColor(asset: #function)
    }

    static var insuranceBackgroundColor: UIColor {
        return makeColor(asset: #function)
    }
    
    static var mainBackgroundColor: UIColor {
        return makeColor(asset: #function)
    }
    
    static var secondaryBackgroundColor: UIColor {
        return makeColor(asset: #function)
    }
    
    static var placeHolderColor: UIColor {
        return makeColor(asset: #function)
    }
    
    static var mainForegroundColor: UIColor {
        return makeColor(asset: #function)
    }
    
    static var secondaryForegroundColor: UIColor {
        return makeColor(asset: #function)
    }

    static var secondaryHighlightColor: UIColor {
        return makeColor(asset: #function)
    }
    
    static var mainAlertColor: UIColor {
        return makeColor(asset: #function)
    }
    
    static var mainHighlightColor: UIColor {
        return makeColor(asset: #function)
    }
    
    static var warningColor: UIColor {
        return UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return makeColor(asset: .red1)
            } else {
                return makeColor(asset: .red1)
            }
        }
    }
    
    static var successColor: UIColor {
        return makeColor(asset: #function)
    }

    static var tabBarItemSelectedColor: UIColor {
        return makeColor(asset: #function)
    }
}

extension Color {
    static func color(_ insuranceSegments: Insurance.Segment) -> UIColor {
        switch insuranceSegments.kind {
        case .home:
            return Color.mainForegroundColor
        case .travel:
            return Color.mainHighlightColor
        case .pets:
            return Color.successColor
        }
    }
}
