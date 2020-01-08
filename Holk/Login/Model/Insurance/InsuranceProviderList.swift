//
//  InsuranceProviderList.swift
//  Holk
//
//  Created by 张梦皓 on 2020-01-08.
//  Copyright © 2020 Holk. All rights reserved.
//

import Foundation

struct InsuranceProvierList: Codable {
    var insuranceProviers: [InsuranceProvider]
    
    private enum CodingKeys: String, CodingKey {
        case insuranceProviers = "insuranceList"
    }
}

extension InsuranceProvierList {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        insuranceProviers = try container.decode([InsuranceProvider].self, forKey: .insuranceProviers)
    }
}

struct InsuranceProvider: Codable {
    let endDate: String
    let id: String
    let insuranceType: String
    let issuerReference: String
    let ssn: String
    let startDate: String
    let taker: String
}
