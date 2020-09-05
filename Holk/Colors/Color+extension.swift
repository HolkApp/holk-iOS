//
//  Color+extension.swift
//  Holk
//
//  Created by 张梦皓 on 2020-09-05.
//  Copyright © 2020 Holk. All rights reserved.
//

import Foundation

extension Color {
    static func tintColor(_ subInsurance: Insurance.SubInsurance) -> UIColor {
        switch subInsurance.kind {
        case .travel:
            return Color.mainForeground
        default:
            return Color.mainHighlight
        }
    }

    static func backgroundColor(_ subInsurance: Insurance.SubInsurance) -> UIColor {
        switch subInsurance.kind {
        case .travel:
            return Color.travelInsuranceBackgroundColor
        default:
            return Color.goodsInsuranceBackgroundColor
        }
    }

    static func iconBackgroundColor(_ subInsurance: Insurance.SubInsurance) -> UIColor {
        switch subInsurance.kind {
        case .travel:
            return Color.travelInsuranceIconBackgroundColor
        default:
            return Color.goodsInsuranceIconBackgroundColor
        }
    }
}
