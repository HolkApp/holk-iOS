//
//  AddonInsurance.swift
//  Holk
//
//  Created by 张梦皓 on 2020-09-24.
//  Copyright © 2020 Holk. All rights reserved.
//

import Foundation

extension Insurance {
    struct AddonInsurance: Codable, Hashable, Equatable {
        var kind: Kind
        let insuranceProviderName: String
        let subtitle: String
        let title: String

        enum Kind: String, Codable, DefaultableDecodable {
            case accidental = "ACCIDENTAL"
            case unknown

            static var decodeFallbackValue = unknown
        }
    }
}

extension Insurance.AddonInsurance {
    init(_ accidentalInsurance: AccidentalInsurance) {
        kind = .accidental
        insuranceProviderName = accidentalInsurance.insuranceProviderName
        title = "Accidental insurance text"
        subtitle = "Mock text, need to get from backend"
    }
}
