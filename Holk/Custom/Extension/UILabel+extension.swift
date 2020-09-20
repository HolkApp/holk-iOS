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
            font = Font.font(name: .raleway, weight: .bold, size: 30)
            setLineHeight(44)
        case .header5:
            font = Font.font(name: .raleway, weight: .bold, size: 26)
            setLineHeight(35)
        case .header6:
            font = Font.font(name: .raleway, weight: .bold, size: 22)
            setLineHeight(30)
            case .header7:
            font = Font.font(name: .montserrat, weight: .regular, size: 18)
            setLineHeight(29)
        case .subHeader1:
            font = Font.font(name: .poppins, weight: .light, size: 22)
            setLineHeight(31)
        case .subHeader2:
            font = Font.font(name: .poppins, weight: .light, size: 15)
            setLineHeight(30.5)
        case .subHeader3:
            font = Font.font(name: .raleway, weight: .regular, size: 22)
            setLineHeight(30.5)
        case .subHeader4:
            font = Font.font(name: .poppins, weight: .regular, size: 25)
            setLineHeight(35)
        case .subHeader5:
            font = Font.font(name: .raleway, weight: .regular, size: 18)
            setLineHeight(24)
        case .cardHeader1:
            font = Font.font(name: .montserrat, weight: .extraBold, size: 35)
            setLineHeight(37)
        case .cardHeader2:
            font = Font.font(name: .montserrat, weight: .extraBold, size: 27)
            setLineHeight(29)
        case .cardHeader3:
            font = Font.font(name: .montserrat, weight: .extraBold, size: 31)
            setLineHeight(39)
        case .titleHeader1:
            font = Font.font(name: .raleway, weight: .bold, size: 18)
            setLineHeight(23)
        case .titleHeader2:
            font = Font.font(name: .raleway, weight: .semiBold, size: 18)
            setLineHeight(24)
        case .titleHeader3:
            font = Font.font(name: .poppins, weight: .regular, size: 15)
            setLineHeight(39)
        case .body1:
            font = Font.font(name: .montserrat, weight: .medium, size: 14)
            setLineHeight(20)
        case .body2:
            font = Font.font(name: .raleway, weight: .regular, size: 16)
            setLineHeight(22)
        case .body3:
            font = Font.font(name: .montserrat, weight: .medium, size: 18)
            setLineHeight(25)
        case .body4:
            font = Font.font(name: .raleway, weight: .semiBold, size: 21)
            setLineHeight(26)
        case .button1:
            font = Font.font(name: .montserrat, weight: .bold, size: 19)
            setLineHeight(35)
        case .number1:
            font = Font.font(name: .poppins, weight: .medium, size: 20)
            setLineHeight(33)
        case .number2:
            font = Font.font(name: .lato, weight: .bold, size: 25)
            setLineHeight(33)
        case .number3:
            font = Font.font(name: .lato, weight: .regular, size: 30)
            setLineHeight(35)
        case .number4:
            font = Font.font(name: .poppins, weight: .medium, size: 40)
            setLineHeight(48)
        case .largeNumber:
            font = Font.font(name: .poppins, weight: .regular, size: 64)
            setLineHeight(80)
        }
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

