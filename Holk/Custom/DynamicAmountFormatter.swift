//
//  DynamicAmountFormatter.swift
//  Holk
//
//  Created by 张梦皓 on 2020-09-23.
//  Copyright © 2020 Holk. All rights reserved.
//

import Foundation

final class DynamicAmountFormatter: NumberFormatter {
    var alwaysHidesCurrencySymbol: Bool {
        get {
            return numberStyle != .currency
        }
        set {
            numberStyle = newValue ? .decimal : .currency
        }
    }

    var alwaysShowsPositiveSign: Bool = false
    var alwaysHidesNegativeSign: Bool = false {
        didSet {
            minusSign = alwaysHidesNegativeSign ? "" : super.minusSign
        }
    }

    override init() {
        super.init()
        self.numberStyle = .currency
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var currencyCode: String! {
        didSet {
            if currencyCode == "SEK" || currencyCode == "NOK" {
                minimumFractionDigits = 0
                maximumFractionDigits = 0
            } else {
                minimumFractionDigits = 2
                maximumFractionDigits = 2
            }
        }
    }

    override func string(from number: NSNumber) -> String? {
        let formatted = super.string(from: number) ?? ""
        guard alwaysShowsPositiveSign, number.doubleValue > 0 else { return formatted }
        return plusSign + formatted
    }

    func string(from amount: Double) -> String {
        return string(from: NSNumber(value: amount)) ?? ""
    }
}
