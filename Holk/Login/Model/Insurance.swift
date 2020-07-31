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
    var address: String
    var segments: [Segment] {
        return [
            Segment(kind: .home, description: "Decription text for what a subInsurance is about, lore isbm"),
            Segment(kind: .travel, description: "This is travel segment of your home insurance."),
            Segment(kind: .pets, description: "This is pets segment of your home insurance.")
        ]
    }

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
    }
}

