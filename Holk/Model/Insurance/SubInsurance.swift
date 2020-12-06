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
            enum Segment: String, Codable, DefaultableDecodable, CaseIterable, Comparable {
                static func < (lhs: Insurance.SubInsurance.Item.Segment, rhs: Insurance.SubInsurance.Item.Segment) -> Bool {
                    return lhs.rawValue < rhs.rawValue
                }

                case home = "AT_HOME"
                case outdoor = "OUT_OF_HOME"
                case other

                static var decodeFallbackValue = other
            }

            let infoText: String
            let value: String
            let name: String
            let key: String
            let iconUrl: URL
            var segment: Segment = .other

            private enum CodingKeys: String, CodingKey {
                case infoText = "infoText"
                case name = "name"
                case value = "value"
                case key = "key"
                case iconUrl = "icon"
                case segment = "segment"
            }
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

        private var id: UUID
        let subtitle: String
        let title: String
        let iconUrl: URL
        let kind: Kind
        // TODO: Remove the mock
        let items: [Item]

        private enum CodingKeys: String, CodingKey {
            case kind = "type"
            case title = "title"
            case subtitle = "subTitle"
            case iconUrl = "icon"
            case items = "itemDefinitionList"
        }
    }
}

extension Insurance.SubInsurance {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = UUID()
        kind = try container.decode(Kind.self, forKey: .kind)
        subtitle = try container.decode(String.self, forKey: .subtitle)
        title = try container.decode(String.self, forKey: .title)
        iconUrl = try container.decode(URL.self, forKey: .iconUrl)
        items = (try? container.decode([Item].self, forKey: .items)) ?? []
    }
}


extension Insurance.SubInsurance.Item {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        infoText = try container.decode(String.self, forKey: .infoText)
        value = try container.decode(String.self, forKey: .value)
        name = try container.decode(String.self, forKey: .name)
        key = try container.decode(String.self, forKey: .key)
        iconUrl = try container.decode(URL.self, forKey: .iconUrl)
        segment = (try? container.decode(Insurance.SubInsurance.Item.Segment.self, forKey: .segment)) ?? .other
    }
}
