//
//  InsuranceIssuerList.swift
//  Holk
//
//  Created by 张梦皓 on 2020-01-07.
//  Copyright © 2020 Holk. All rights reserved.
//

import Foundation

struct InsuranceIssuerList: Codable {
    let insuranceIssuers: [InsuranceIssuer]
    
    private enum CodingKeys: String, CodingKey {
        case insuranceIssuers = "providerStatusList"
    }
}

extension InsuranceIssuerList {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        insuranceIssuers = try container.decode([InsuranceIssuer].self, forKey: .insuranceIssuers)
    }
}

struct InsuranceIssuer: Codable {
    enum InsuranceIssuerStatus: String, ExpressibleByStringLiteral {
        init(stringLiteral value: String) {
            switch value.uppercased() {
            case "AVAILABLE":
                self = .available
            case "UNAVAILABLE":
                self = .unavailable
            default:
                self = .unknown
            }
        }
        
        case available
        case unavailable
        case unknown
    }
    
    let name: String
    let insuranceIssuerStatus: String
    let websiteUrl: URL
}
