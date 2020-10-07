//
//  Colors.swift
//  Holk
//
//  Created by 张梦皓 on 2019-06-08.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit
enum Color {

    // Color from the Design
    enum ColorProvider: String {
        case blue1
        case blue2
        case blue3
        case blue5
        case blue6
        case blue8
        case blue9
        case green1
        case green2
        case grey1
        case grey2
        case grey3
        case grey4
        case grey5
        case pink1
        case pink2
        case red1
        case yellow2
        case yellow3
    }

    fileprivate static func makeColor(asset name: ColorProvider) -> UIColor {
        guard let color = UIColor(named: name.rawValue) else {
            fatalError("No asset found with name " + name.rawValue)
        }
        return color
    }

    fileprivate static func makeColor(asset name: String) -> UIColor {
        guard let color = UIColor(named: name) else {
            fatalError("No asset found with name " + name)
        }
        return color
    }
}

// MARK: Main Color
extension Color {
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
        return UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return makeColor(asset: .blue1)
            } else {
                return makeColor(asset: .blue1)
            }
        }
    }

    static var mainBackground: UIColor {
        return makeColor(asset: #function)
    }

    static var secondaryBackground: UIColor {
        return UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return .white
            } else {
                return .white
            }
        }
    }

    static var mainForeground: UIColor {
        return UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return .black
            } else {
                return .black
            }
        }
    }

    static var secondaryForeground: UIColor {
        return UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return makeColor(asset: .grey4)
            } else {
                return makeColor(asset: .grey4)
            }
        }
    }

    static var secondaryHighlight: UIColor {
        return UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return makeColor(asset: .blue5)
            } else {
                return makeColor(asset: .blue5)
            }
        }
    }

    static var mainHighlight: UIColor {
        return makeColor(asset: #function)
    }

    static var label: UIColor {
        return UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return .black
            } else {
                return .black
            }
        }
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

    static var separator: UIColor {
        return UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return makeColor(asset: .grey5)
            } else {
                return makeColor(asset: .grey5)
            }
        }
    }

    static var placeholder: UIColor {
        return UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return makeColor(asset: .grey4)
            } else {
                return makeColor(asset: .grey4)
            }
        }
    }

    static var thinkOfSeparator: UIColor {
        return UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return makeColor(asset: .blue2)
            } else {
                return makeColor(asset: .blue2)
            }
        }
    }

    static var gapSeparator: UIColor {
        return UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return makeColor(asset: .grey3)
            } else {
                return makeColor(asset: .grey3)
            }
        }
    }
}

// MARK: Status Color
extension Color {
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

}

// MARK: Suggestion
extension Color {
    static var suggestionBackground: UIColor {
        return UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return makeColor(asset: .blue9)
            } else {
                return makeColor(asset: .blue9)
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

    static var paragraphIconBackground: UIColor {
        return UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return makeColor(asset: .grey1)
            } else {
                return makeColor(asset: .grey1)
            }
        }
    }
}

// MARK: Color extension for SubInsurance
extension Color {
    static func subInsuranceBackgroundColor(_ thinkOf: ThinkOfSuggestion) -> UIColor {
        guard let subInsuranceKind = thinkOf.tags.first(where: { $0.key == .subInsurance })?.value, let kind = Insurance.SubInsurance.Kind(rawValue: subInsuranceKind) else {
            return makeColor(asset: .blue8)
        }
        return subInsuranceBackgroundColor(kind)
    }

    static func subInsuranceBackgroundColor(_ subInsuranceKind: Insurance.SubInsurance.Kind) -> UIColor {
        switch subInsuranceKind {
        case .movables:
            return makeColor(asset: .yellow2)
        case .travel:
            return makeColor(asset: .blue8)
        case .liability:
            return makeColor(asset: .red1)
        case .legal:
            return makeColor(asset: .grey3)
        case .assault:
            return makeColor(asset: .green1)
        case .unknown:
            return makeColor(asset: .blue8)
        }
    }

    static func subInsuranceIconBackgroundColor(_ thinkOf: ThinkOfSuggestion) -> UIColor {
        guard let subInsuranceKind = thinkOf.tags.first(where: { $0.key == .subInsurance })?.value, let kind = Insurance.SubInsurance.Kind(rawValue: subInsuranceKind) else {
            return makeColor(asset: .blue6)
        }
        return subInsuranceIconBackgroundColor(kind)
    }

    static func subInsuranceIconBackgroundColor(_ subInsuranceKind: Insurance.SubInsurance.Kind) -> UIColor {
        switch subInsuranceKind {
        case .movables:
            return makeColor(asset: .yellow3)
        case .travel:
            return makeColor(asset: .blue6)
        case .liability:
            return makeColor(asset: .pink2)
        case .legal:
            return makeColor(asset: .grey5)
        case .assault:
            return makeColor(asset: .green2)
        case .unknown:
            return makeColor(asset: .blue6)
        }
    }
}
