//
//  HolkLabel.swift
//  Holk
//
//  Created by 张梦皓 on 2020-10-08.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

class HolkLabel: UILabel {
    var styleGuide: FontStyleGuide = .body1 {
        didSet {
            super.setStyleGuide(styleGuide)
        }
    }

    override var text: String? {
        didSet {
            super.setStyleGuide(styleGuide)
        }
    }
}

fileprivate extension UILabel {
    func setStyleGuide(_ styleGuide: FontStyleGuide) {
        font = styleGuide.font
        setLineHeight(styleGuide.lineHeight)
    }

    func setLineHeight(_ lineHeight: CGFloat) {
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
