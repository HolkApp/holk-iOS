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
        let body: String
        let header: String

        enum Kind: String, Codable {
            case accidental = "ACCIDENTAL"
        }
    }
}

extension Insurance.AddonInsurance {
    init(_ accidentalInsurance: AccidentalInsurance) {
        kind = .accidental
        insuranceProviderName = accidentalInsurance.insuranceProviderName
        header = "Accidental insurance text"
        body = "Mock text, need to get from backend"
    }
}
