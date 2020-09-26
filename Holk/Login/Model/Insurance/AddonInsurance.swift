//
//  AddonInsurance.swift
//  Holk
//
//  Created by 张梦皓 on 2020-09-24.
//  Copyright © 2020 Holk. All rights reserved.
//

import Foundation


struct AddonInsurance: Codable, Hashable, Equatable {
    var kind: Kind
    let insuranceProviderName: String

    enum Kind: String, Codable {
        case accidental = "ACCIDENTAL"
    }
}

extension AddonInsurance {
    init(_ accidentalInsurance: AccidentalInsurance) {
        kind = .accidental
        insuranceProviderName = accidentalInsurance.insuranceProviderName
    }
}
