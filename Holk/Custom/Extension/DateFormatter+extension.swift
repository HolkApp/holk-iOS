//
//  DateFormatter+extension.swift
//  Holk
//
//  Created by 张梦皓 on 2020-02-17.
//  Copyright © 2020 Holk. All rights reserved.
//

import Foundation

extension DateFormatter {
    static let yyyyMMddDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .iso8601)
        return formatter
    }()

    static let longDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.calendar = Calendar(identifier: .iso8601)
        return formatter
    }()

    static let simpleDateFormatter: DateFormatter = {
        let formatter = DateFormatter()

        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        formatter.calendar = Calendar(identifier: .iso8601)
        return formatter
    }()
}

