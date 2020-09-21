//
//  UILabel+extension.swift
//  Holk
//
//  Created by 张梦皓 on 2020-04-12.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

extension UILabel {
    func set(text: String?, with styleGuide: FontStyleGuide) {
        self.text = text
        setStyleGuide(styleGuide)
    }

    func setStyleGuide(_ styleGuide: FontStyleGuide) {
        font = styleGuide.font
        setLineHeight(styleGuide.lineHeight)
    }

    private func setLineHeight(_ lineHeight: CGFloat) {
        guard let font = font else { return }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineHeight - font.lineHeight
        paragraphStyle.alignment = textAlignment

        let attrString: NSMutableAttributedString
        if let attributedText = attributedText {
            attrString = NSMutableAttributedString(attributedString: attributedText)
        } else {
            attrString = NSMutableAttributedString(string: text ?? "")
            attrString.addAttribute(.font, value: font, range: NSRange(location: 0, length: attrString.length))
        }

        attrString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attrString.length))
        self.attributedText = attrString
    }
}

