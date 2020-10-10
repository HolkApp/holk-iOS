//
//  Insurance.swift
//  Holk
//
//  Created by 张梦皓 on 2020-06-14.
//  Copyright © 2020 Holk. All rights reserved.
//

import Foundation

struct Insurance: Codable, Hashable, Equatable {
    struct ID: Hashable, Codable, ExpressibleByStringLiteral {
        init(stringLiteral value: String) {
            self.value = value
        }

        init(_ value: String) {
            self.value = value
        }

        let value: String
    }

    enum Kind: String, Codable, DefaultableDecodable {
        case homeInsurance = "HEMFORSAKRING"
        case unknown

        static var decodeFallbackValue = unknown

        var description: String {
            switch self {
            case .homeInsurance:
                return "Hemförsäkring"
            case .unknown:
                return self.rawValue
            }
        }
    }

    let id: Insurance.ID
    let insuranceProviderName: String
    let kind: Kind
    let providerReference: String
    let ssn: String
    let startDate: Date
    let endDate: Date
    let userName: String
    let address: String
    let cost: Cost
    var subInsurances: [SubInsurance]
    var addonInsurances: [AddonInsurance] = []
    var accidentalInsurances: [AccidentalInsurance]
}

extension Insurance {
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case insuranceProviderName = "insuranceProviderName"
        case kind = "insuranceType"
        case providerReference = "providerReference"
        case startDate = "startDate"
        case endDate = "endDate"
        case ssn = "takerPersonalNumber"
        case userName = "taker"
        case address = "address"
        case cost = "cost"
        case subInsurances = "subInsuranceList"
        case accidentalInsurances = "accidentalInsuranceList"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let idString = try container.decode(String.self, forKey: .id)
        id = Insurance.ID(idString)
        insuranceProviderName = try container.decode(String.self, forKey: .insuranceProviderName)
        kind = try container.decode(Kind.self, forKey: .kind)
        providerReference = try container.decode(String.self, forKey: .providerReference)
        startDate = try container.decode(Date.self, forKey: .startDate)
        endDate = try container.decode(Date.self, forKey: .endDate)
        ssn = try container.decode(String.self, forKey: .ssn)
        userName = try container.decode(String.self, forKey: .userName)
        address = try container.decode(String.self, forKey: .address)
        cost = try container.decode(Cost.self, forKey: .cost)
        subInsurances = try container.decode([SubInsurance].self, forKey: .subInsurances).sorted()
        accidentalInsurances = try container.decode([AccidentalInsurance].self, forKey: .accidentalInsurances)
        addonInsurances = accidentalInsurances.map({ AddonInsurance($0) })
    }
}
