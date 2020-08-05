//
//  Insurance.swift
//  Holk
//
//  Created by 张梦皓 on 2020-06-14.
//  Copyright © 2020 Holk. All rights reserved.
//

import Foundation

struct Insurance: Codable, Hashable, Equatable {

    struct SubInsurance: Codable, Hashable, Equatable {
        enum Kind: String, Codable {
            case allRisk = "ALLRISK"
            case assault = "ASSAULT"
            case legal = "LEGAL"
            case child = "CHILD_INSURANCE"
            case movables = "MOVABLES"
            case responsibility = "RESPONSIBILITY"
            case travel = "TRAVEL"
        }

        let body: String
        let header: String
        let iconUrl: URL
        let kind: Kind

        private enum CodingKeys: String, CodingKey {
            case kind = "type"
            case header = "headerText"
            case body = "bodyText"
            case iconUrl = "iconUrl"
        }
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
        case homeInsurnace = "HEMFORSAKRING"

        var description: String {
            switch self {
            case .homeInsurnace:
                return "Hemförsäkring"
            }
        }
    }

    let id: String
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
        case subInsurances = "homeInsuranceSubInsuranceDto"
    }
}

extension Insurance {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
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
    }
}

extension Insurance.SubInsurance {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        kind = try container.decode(Kind.self, forKey: .kind)
        body = try container.decode(String.self, forKey: .body)
        header = try container.decode(String.self, forKey: .header)
        iconUrl = try container.decode(URL.self, forKey: .iconUrl)
    }
}
