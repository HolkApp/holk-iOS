//
//  FontStyleGuide.swift
//  Holk
//
//  Created by 张梦皓 on 2020-04-12.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

enum FontStyleGuide {
    case header1
    case header2
    case header3
    case header4
    case header5
    case header6
    case header7
    case subHeader1
    case subHeader2
    case subHeader3
    case subHeader4
    case subHeader5
    case cardHeader1
    case cardHeader2
    case cardHeader3
    case titleHeader1
    case titleHeader2
    case titleHeader3
    case button1
    case body1
    case body2
    case body3
    case body4
    case number1
    case number2
    case number3
    case number4
    case largeNumber

    var lineHeight: CGFloat {
        switch self {
        case .header1:
            return 58
        case .header2:
            return 57
        case .header3:
            return 46
        case .header4:
            return 44
        case .header5:
            return 35
        case .header6:
            return 30
        case .header7:
            return 29
        case .subHeader1:
            return 31
        case .subHeader2:
            return 30.5
        case .subHeader3:
            return 30.5
        case .subHeader4:
            return 35
        case .subHeader5:
            return 24
        case .cardHeader1:
            return 37
        case .cardHeader2:
            return 29
        case .cardHeader3:
            return 39
        case .titleHeader1:
            return 23
        case .titleHeader2:
            return 24
        case .titleHeader3:
            return 39
        case .body1:
            return 20
        case .body2:
            return 22
        case .body3:
            return 25
        case .body4:
            return 26
        case .button1:
            return 35
        case .number1:
            return 33
        case .number2:
            return 33
        case .number3:
            return 35
        case .number4:
            return 48
        case .largeNumber:
            return 80
        }
    }

    var font: UIFont {
        switch self {
        case .header1:
            return Font.font(name: .montserrat, weight: .extraBold, size: 50)
        case .header2:
            return Font.font(name: .montserrat, weight: .extraBold, size: 45)
        case .header3:
            return Font.font(name: .montserrat, weight: .extraBold, size: 39)
        case .header4:
            return Font.font(name: .raleway, weight: .bold, size: 30)
        case .header5:
            return Font.font(name: .raleway, weight: .bold, size: 26)
        case .header6:
            return Font.font(name: .raleway, weight: .bold, size: 22)
        case .header7:
            return Font.font(name: .montserrat, weight: .regular, size: 18)
        case .subHeader1:
            return Font.font(name: .poppins, weight: .light, size: 22)
        case .subHeader2:
            return Font.font(name: .poppins, weight: .light, size: 15)
        case .subHeader3:
            return Font.font(name: .raleway, weight: .regular, size: 22)
        case .subHeader4:
            return Font.font(name: .poppins, weight: .regular, size: 25)
        case .subHeader5:
            return Font.font(name: .raleway, weight: .regular, size: 18)
        case .cardHeader1:
            return Font.font(name: .montserrat, weight: .extraBold, size: 35)
        case .cardHeader2:
            return Font.font(name: .montserrat, weight: .extraBold, size: 27)
        case .cardHeader3:
            return Font.font(name: .montserrat, weight: .extraBold, size: 31)
        case .titleHeader1:
            return Font.font(name: .raleway, weight: .bold, size: 18)
        case .titleHeader2:
            return Font.font(name: .raleway, weight: .semiBold, size: 18)
        case .titleHeader3:
            return Font.font(name: .poppins, weight: .regular, size: 15)
        case .body1:
            return Font.font(name: .montserrat, weight: .medium, size: 14)
        case .body2:
            return Font.font(name: .raleway, weight: .regular, size: 16)
        case .body3:
            return Font.font(name: .montserrat, weight: .medium, size: 18)
        case .body4:
            return Font.font(name: .raleway, weight: .semiBold, size: 21)
        case .button1:
            return Font.font(name: .montserrat, weight: .bold, size: 19)
        case .number1:
            return Font.font(name: .poppins, weight: .medium, size: 20)
        case .number2:
            return Font.font(name: .lato, weight: .bold, size: 25)
        case .number3:
            return Font.font(name: .lato, weight: .regular, size: 30)
        case .number4:
            return Font.font(name: .poppins, weight: .medium, size: 40)
        case .largeNumber:
            return Font.font(name: .poppins, weight: .regular, size: 64)
        }
    }
}
