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
            setStyleGuide(styleGuide)
        }
    }

    override var text: String? {
        didSet {
            setStyleGuide(styleGuide)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setStyleGuide(styleGuide)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyleGuide(_ styleGuide: FontStyleGuide) {
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
