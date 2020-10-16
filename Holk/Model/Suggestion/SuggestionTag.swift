//
//  SuggestionTag.swift
//  Holk
//
//  Created by 张梦皓 on 2020-09-27.
//  Copyright © 2020 Holk. All rights reserved.
//

import Foundation

struct SuggestionTag: Codable, Hashable {
    let key: Key
    let value: String

    enum Key: String, Codable, DefaultableDecodable {
        case subInsurance = "HOMEINSURANCE_SUBINSURANCE"
        case unknown

        static var decodeFallbackValue = unknown
    }
}
