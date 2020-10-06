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
