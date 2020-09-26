//
//  Kind.swift
//  Holk
//
//  Created by 张梦皓 on 2020-09-23.
//  Copyright © 2020 Holk. All rights reserved.
//

import Foundation

enum Kind: String, Codable {
    case homeInsurance = "HEMFORSAKRING"

    var description: String {
        switch self {
        case .homeInsurance:
            return "Hemförsäkring"
        }
    }
}
