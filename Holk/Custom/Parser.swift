//
//  Parser.swift
//  Holk
//
//  Created by 张梦皓 on 2020-01-12.
//  Copyright © 2020 Holk. All rights reserved.
//

import MarkdownKit

final class Parser {
    static func parse(markdownString: String, font: UIFont, linkFont: UIFont? = nil, textColor: UIColor, linkColor: UIColor? = nil) -> NSAttributedString {
        let markdownParser = MarkdownParser(font: font, color: textColor)
        markdownParser.link.font = linkFont ?? font
        markdownParser.link.color = linkColor ?? textColor
        return markdownParser.parse(markdownString)
    }
}
