//
//  Font+FontAwesome.swift
//  Holk
//
//  Created by 张梦皓 on 2019-09-16.
//  Copyright © 2019 Holk. All rights reserved.
//

import FontAwesome_swift

extension Font {
    static func registerFontAwsomePro() {
        FontAwesomeConfig.usesProFonts = true
    }
    
    static func fontAwesome(style: FontAwesomeStyle, size: Size) -> UIFont {
        UIFont.fontAwesome(ofSize: size.pointSize, style: style)
    }
}
