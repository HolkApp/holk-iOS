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
        case blue9
        case green1
        case grey1
        case grey2
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
    
    static var landingBackground: UIColor {
        return makeColor(asset: #function)
    }
    
    static var landingSecondaryBackground: UIColor {
        return makeColor(asset: #function)
    }

    static var suggestionCardBackground: UIColor {
        return makeColor(asset: #function)
    }

    static var suggestionCardPressDownBackground: UIColor {
        return makeColor(asset: #function)
    }

    static var insuranceBackground: UIColor {
        return makeColor(asset: #function)
    }
    
    static var mainBackground: UIColor {
        return makeColor(asset: #function)
    }
    
    static var secondaryBackground: UIColor {
        return makeColor(asset: #function)
    }
    
    static var placeHolder: UIColor {
        return makeColor(asset: #function)
    }
    
    static var mainForeground: UIColor {
        return makeColor(asset: #function)
    }
    
    static var secondaryForeground: UIColor {
        return UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return makeColor(asset: .grey2)
            } else {
                return makeColor(asset: .grey2)
            }
        }
    }

    static var secondaryHighlight: UIColor {
        return makeColor(asset: #function)
    }
    
    static var mainHighlight: UIColor {
        return makeColor(asset: #function)
    }

    static var success: UIColor {
        return UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return makeColor(asset: .green1)
            } else {
                return makeColor(asset: .green1)
            }
        }
    }
    
    static var warning: UIColor {
        return UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return makeColor(asset: .red1)
            } else {
                return makeColor(asset: .red1)
            }
        }
    }

    static var tabBarItemSelected: UIColor {
        return makeColor(asset: #function)
    }

    static var secondaryLabel: UIColor {
        return UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return .white
            } else {
                return .white
            }
        }
    }
}

// MARK: Suggestion
extension Color {
    static var thinkOfIconBackground: UIColor {
        return UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return makeColor(asset: .blue9)
            } else {
                return makeColor(asset: .blue9)
            }
        }
    }

    static var thinkOfBackground: UIColor {
        return UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return makeColor(asset: .blue8)
            } else {
                return makeColor(asset: .blue8)
            }
        }
    }

    static var gapLabel: UIColor {
        return UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return makeColor(asset: .pink1)
            } else {
                return makeColor(asset: .pink1)
            }
        }
    }
}

extension Color {
    static func color(_ insuranceSegments: Insurance.Segment) -> UIColor {
        switch insuranceSegments.kind {
        case .home:
            return Color.mainForeground
        case .travel:
            return Color.mainHighlight
        case .pets:
            return Color.success
        }
    }
}
