//
//  AccidentalInsurance.swift
//  Holk
//
//  Created by 张梦皓 on 2020-09-23.
//  Copyright © 2020 Holk. All rights reserved.
//

import Foundation

struct AccidentalInsurance: Codable, Hashable, Equatable {
    struct ID: Hashable, Codable, ExpressibleByStringLiteral {
        init(stringLiteral value: String) {
            self.value = value
        }

        init(_ value: String) {
            self.value = value
        }

        let value: String
    }
}
