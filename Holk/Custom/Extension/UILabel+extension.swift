//
//  UILabel+extension.swift
//  Holk
//
//  Created by 张梦皓 on 2020-04-12.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

extension UILabel {
    func setStyleGuide(_ styleGuide: FontStyleGuide) {
        switch styleGuide {
        case .header1:
            font = Font.font(name: .montserrat, weight: .extraBold, size: 50)
            setLineHeight(58)
        case .header2:
            font = Font.font(name: .montserrat, weight: .extraBold, size: 45)
            setLineHeight(57)
        case .header3:
            font = Font.font(name: .montserrat, weight: .extraBold, size: 39)
            setLineHeight(46)
        case .header4:
            font = Font.font(name: .poppins, weight: .semiBold, size: 30)
            setLineHeight(39)
        case .header5:
            font = Font.font(name: .poppins, weight: .semiBold, size: 25)
            setLineHeight(20)
        case .body1:
            font = Font.font(name: .montserrat, weight: .regular, size: 13)
            setLineHeight(17)
        }
    }

    func setLineHeight(_ lineHeight: CGFloat) {
        guard let font = font else { return }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = max(lineHeight - font.lineHeight, 0)
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

