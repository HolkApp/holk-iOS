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

    struct Cost: Codable, Hashable, Equatable {
        enum Frequency: String, Codable {
            case annual = "ANNUAL"
            case monthly = "MONTHLY"
        }

        let paymentFrequency: Frequency
        let price: Double

        var monthlyPrice: Double {
            switch paymentFrequency {
            case .annual: return price / 12.0
            case .monthly: return price
            }
        }
        var annualPrice: Double {
            switch paymentFrequency {
            case .annual: return price
            case .monthly: return price * 12.0
            }
        }
    }

    enum Kind: String, Codable {
        case homeInsurance = "HEMFORSAKRING"

        var description: String {
            switch self {
            case .homeInsurance:
                return "Hemförsäkring"
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
        subInsurances = try container.decode([SubInsurance].self, forKey: .subInsurances)
        accidentalInsurances = try container.decode([AccidentalInsurance].self, forKey: .accidentalInsurances)
        addonInsurances = accidentalInsurances.map({ AddonInsurance($0) })
    }
}
