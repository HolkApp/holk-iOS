//
//  Insurance.swift
//  Holk
//
//  Created by 张梦皓 on 2020-06-14.
//  Copyright © 2020 Holk. All rights reserved.
//

import Foundation

struct Insurance: Codable, Hashable, Equatable {
    struct Segment: Hashable {
        let kind: Kind
        let description: String

        enum Kind: String {
            case travel
            case home
            case pets
        }
    }

    enum InsuranceType: String, Codable, CustomStringConvertible {
        case homeInsurnace = "HEMFORSAKRING"

        var description: String {
            switch self {
            case .homeInsurnace:
                return "Hemförsäkring"
            }
        }
    }

    let id: String
    let insuranceProvider: InsuranceProvider
    let insuranceType: InsuranceType
    let providerReference: String
    let ssn: String
    let startDate: Date
    let endDate: Date
    let username: String
    var address: String {
        "Mocked Sveavägen 140"
    }
    var segments: [Segment] {
        return [
            Segment(kind: .home, description: "Decription text for what a subinsurance is about, lore isbm"),
            Segment(kind: .travel, description: "This is travel segment of your home insurance."),
            Segment(kind: .pets, description: "This is pets segment of your home insurance.")
        ]
    }

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case insuranceProvider = "insuranceProvider"
        case insuranceType = "insuranceType"
        case providerReference = "providerReference"
        case startDate = "startDate"
        case endDate = "endDate"
        case ssn = "ssn"
        case username = "taker"
    }
}

extension Insurance {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        insuranceProvider = try container.decode(InsuranceProvider.self, forKey: .insuranceProvider)
        insuranceType = try container.decode(InsuranceType.self, forKey: .insuranceType)
        providerReference = try container.decode(String.self, forKey: .providerReference)
        startDate = try container.decode(Date.self, forKey: .startDate)
        endDate = try container.decode(Date.self, forKey: .endDate)
        ssn = try container.decode(String.self, forKey: .ssn)
        username = try container.decode(String.self, forKey: .username)
    }
}

