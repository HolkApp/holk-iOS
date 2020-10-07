//
//  SubInsurance.swift
//  Holk
//
//  Created by 张梦皓 on 2020-09-25.
//  Copyright © 2020 Holk. All rights reserved.
//

import Foundation

extension Insurance {
    struct SubInsurance: Codable, Hashable, Equatable {
        enum Kind: String, Codable, DefaultableDecodable {
            case liability = "LIABILITY"
            case assault = "ASSAULT"
            case legal = "LEGAL"
            case movables = "MOVABLES"
            case travel = "TRAVEL"
            case unknown

            static var decodeFallbackValue = unknown
        }

        let subtitle: String
        let title: String
        let iconUrl: URL
        let kind: Kind

        private enum CodingKeys: String, CodingKey {
            case kind = "type"
            case title = "title"
            case subtitle = "subtitle"
            case iconUrl = "iconUrl"
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
