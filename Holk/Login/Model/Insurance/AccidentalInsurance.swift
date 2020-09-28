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

    let id: AccidentalInsurance.ID
    let insuranceProviderName: String
    let providerReference: String
    let insuranceObject: String
    let cost: Cost
    let startDate: Date
    let endDate: Date

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case insuranceProviderName = "insuranceProviderName"
        case providerReference = "providerReference"
        case insuranceObject = "insuranceObject"
        case startDate = "startDate"
        case endDate = "endDate"
        case cost = "cost"
    }
}

extension AccidentalInsurance {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let idString = try container.decode(String.self, forKey: .id)
        id = AccidentalInsurance.ID(idString)
        insuranceProviderName = try container.decode(String.self, forKey: .insuranceProviderName)
        insuranceObject = try container.decode(String.self, forKey: .insuranceObject)
        providerReference = try container.decode(String.self, forKey: .providerReference)
        startDate = try container.decode(Date.self, forKey: .startDate)
        endDate = try container.decode(Date.self, forKey: .endDate)
        cost = try container.decode(Cost.self, forKey: .cost)
    }
}
