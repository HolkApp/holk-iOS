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
            setLineHeight(44)
        case .header5:
            font = Font.font(name: .poppins, weight: .semiBold, size: 25)
            setLineHeight(35)
        case .header6:
            font = Font.font(name: .poppins, weight: .semiBold, size: 21)
            setLineHeight(30)
            case .header7:
            font = Font.font(name: .montserrat, weight: .regular, size: 18)
            setLineHeight(29)
        case .subHeaders1:
            font = Font.font(name: .poppins, weight: .light, size: 22)
            setLineHeight(30)
        case .subHeaders2:
            font = Font.font(name: .poppins, weight: .light, size: 15)
            setLineHeight(30)
        case .subHeaders3:
            font = Font.font(name: .poppins, weight: .light, size: 19)
            setLineHeight(30)
        case .subHeaders4:
            font = Font.font(name: .poppins, weight: .regular, size: 25)
            setLineHeight(30)
        case .cardHeader1:
            font = Font.font(name: .montserrat, weight: .extraBold, size: 35)
            setLineHeight(37)
        case .cardHeader2:
            font = Font.font(name: .montserrat, weight: .extraBold, size: 28)
            setLineHeight(32)
        case .titleHeader1:
            font = Font.font(name: .poppins, weight: .semiBold, size: 18)
            setLineHeight(14)
        case .body1:
            font = Font.font(name: .montserrat, weight: .medium, size: 14)
            setLineHeight(20)
        case .body2:
            font = Font.font(name: .montserrat, weight: .regular, size: 16)
            setLineHeight(23)
        case .body3:
            font = Font.font(name: .montserrat, weight: .medium, size: 18)
            setLineHeight(25)
        case .numbers1:
            font = Font.font(name: .poppins, weight: .medium, size: 20)
            setLineHeight(33)
        case .numbers2:
            font = Font.font(name: .lato, weight: .bold, size: 25)
            setLineHeight(33)
        case .numbers3:
            font = Font.font(name: .lato, weight: .regular, size: 30)
            setLineHeight(35)
        case .largeNumber:
            font = Font.font(name: .poppins, weight: .regular, size: 64)
            setLineHeight(76)
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

