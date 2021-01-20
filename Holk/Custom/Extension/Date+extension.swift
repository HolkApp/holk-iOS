//
//  Date+extension.swift
//  Holk
//
//  Created by 张梦皓 on 2020-06-14.
//  Copyright © 2020 Holk. All rights reserved.
//

import Foundation

extension Date {
    var expirationDaysLeft: ExpirationDaysLeft? {
        let components = Calendar.current.dateComponents([.day], from: Date(), to: self)
        guard let days = components.day else { return nil }
        if days > 0 {
            return .valid(days)
        } else if days == 0 {
            return .today
        } else {
            return .expired
        }
    }
}

enum ExpirationDaysLeft {
    case valid(Int)
    case today
    case expired
}
