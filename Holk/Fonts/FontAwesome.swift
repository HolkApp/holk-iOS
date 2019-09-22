//
//  Font+FontAwesome.swift
//  Holk
//
//  Created by 张梦皓 on 2019-09-16.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

extension UIFont {
    static func fontAwesome(ofSize fontSize: CGFloat, style: FontAwesomeStyle) -> UIFont {
        loadFontAwesome(ofStyle: style)
        return UIFont(name: style.fontName(), size: fontSize)!
    }
    
    static func loadFontAwesome(ofStyle style: FontAwesomeStyle) {
        if UIFont.fontNames(forFamilyName: style.fontFamilyName()).contains(style.fontName()) {
            return
        }

        FontLoader.loadFont(style.fontFilename())
    }
}

// Inspired from https://github.com/thii/FontAwesome.swift/tree/master/FontAwesome
public struct FontAwesomeConfig {

    // Marked private to prevent initialization of this struct.
    private init() { }

    /// Taken from FontAwesome.io's Fixed Width Icon CSS.
    public static let fontAspectRatio: CGFloat = 1.28571429
}

enum FontAwesomeStyle: String {
    case solid
    /// WARNING: Font Awesome Free doesn't include a Light variant. Using this with Free will fallback to Regular.
    case light
    case regular
    case brands

    func fontName() -> String {
        switch self {
        case .solid:
            return "FontAwesome5Pro-Solid"
        case .light:
            return "FontAwesome5Pro-Light"
        case .regular:
            return "FontAwesome5Pro-Regular"
        case .brands:
            return "FontAwesome5Brands-Regular"
        }
    }

    func fontFilename() -> String {
        switch self {
        case .solid:
            return "Font Awesome 5 Pro-Solid-900"
        case .light:
            return "Font Awesome 5 Pro-Light-300"
        case .regular:
            return "Font Awesome 5 Pro-Regular-400"
        case .brands:
            return "Font Awesome 5 Brands-Regular-400"
        }
    }

    func fontFamilyName() -> String {
        switch self {
        case .brands:
            return "Font Awesome 5 Brands"
        case .regular,
             .light,
             .solid:
            return "Font Awesome 5 Pro"
        }
    }
}
