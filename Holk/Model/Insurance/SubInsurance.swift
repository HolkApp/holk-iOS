//
//  SubInsurance.swift
//  Holk
//
//  Created by 张梦皓 on 2020-09-25.
//  Copyright © 2020 Holk. All rights reserved.
//

import Foundation

extension Insurance {
    struct SubInsurance: Codable, Hashable, Equatable, Comparable {
        static func < (lhs: Insurance.SubInsurance, rhs: Insurance.SubInsurance) -> Bool {
            return lhs.kind < rhs.kind
        }

        struct Item: Codable, Hashable, Equatable {
            let infoText: String
            let maxAmount: String
            let name: String
            let result: String
        }

        enum Kind: String, Codable, DefaultableDecodable, CaseIterable, Comparable {
            case movables = "MOVABLES"
            case travel = "TRAVEL"
            case assault = "ASSAULT"
            case liability = "LIABILITY"
            case legal = "LEGAL"
            case unknown

            static var decodeFallbackValue = unknown

            static func < (lhs: Insurance.SubInsurance.Kind, rhs: Insurance.SubInsurance.Kind) -> Bool {
                return lhs.comparisonValue < rhs.comparisonValue
            }

            private var comparisonValue: Int {
                switch self {
                case .movables:
                    return 0
                case .travel:
                    return 1
                case .assault:
                    return 2
                case .liability:
                    return 3
                case .legal:
                    return 4
                case .unknown:
                    return 5
                }
            }
        }

        let subtitle: String
        let title: String
        let iconUrl: URL
        let kind: Kind

        private enum CodingKeys: String, CodingKey {
            case kind = "type"
            case title = "title"
            case subtitle = "subTitle"
            case iconUrl = "icon"
        }
    }
}

extension Insurance.SubInsurance {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        kind = try container.decode(Kind.self, forKey: .kind)
        subtitle = try container.decode(String.self, forKey: .subtitle)
        title = try container.decode(String.self, forKey: .title)
        iconUrl = try container.decode(URL.self, forKey: .iconUrl)
    }
}
