//
//  DateFormatter+extension.swift
//  Holk
//
//  Created by 张梦皓 on 2020-02-17.
//  Copyright © 2020 Holk. All rights reserved.
//

import Foundation

extension DateFormatter {
    static let simpleDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.doesRelativeDateFormatting = true
        return formatter
    }()
}

