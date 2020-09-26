//
//  Cost.swift
//  Holk
//
//  Created by 张梦皓 on 2020-09-23.
//  Copyright © 2020 Holk. All rights reserved.
//

import Foundation

struct Cost: Codable, Hashable, Equatable {
    enum Frequency: String, Codable {
        case annual = "ANNUAL"
        case monthly = "MONTHLY"
    }

    let paymentFrequency: Frequency
    let price: Double

    var monthlyPrice: Double {
        switch paymentFrequency {
        case .annual: return price / 12.0
        case .monthly: return price
        }
    }
    var annualPrice: Double {
        switch paymentFrequency {
        case .annual: return price
        case .monthly: return price * 12.0
        }
    }
}
