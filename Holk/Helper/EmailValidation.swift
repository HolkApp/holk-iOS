//
//  EmailValidation.swift
//  Holk
//
//  Created by 张梦皓 on 2020-04-29.
//  Copyright © 2020 Holk. All rights reserved.
//

import Foundation

class EmailValidation {
    //From the Android SDK
    static let emailPattern = "[a-zA-Z0-9\\+\\.\\_\\%\\-\\+]{1,256}\\@[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}(\\.[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25})+"

    static func isValid(_ email: String) -> Bool {
        let range = NSRange(location: 0, length: email.count)
        guard let regex = try? NSRegularExpression(pattern: Self.emailPattern) else { return false}
        return regex.firstMatch(in: email, options: [], range: range) != nil
    }
}
