//
//  ScrapingStatusResponse.swift
//  Holk
//
//  Created by 张梦皓 on 2020-01-14.
//  Copyright © 2020 Holk. All rights reserved.
//

import Foundation
enum ScrapingStatus: String, Codable {
    case unintiated = "UNINITIATED"
    case initiated = "INITIATED"
    case loggedin = "LOGGED_IN"
    case completed = "COMPLETED"
    case failed = "FAILED"
}

struct ScrapingStatusResponse: Codable {
    let scrapingStatus: ScrapingStatus
    
    private enum CodingKeys: String, CodingKey {
        case scrapingStatus = "scrapingStatus"
    }
}

extension ScrapingStatusResponse {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let scrapingStatusString = try container.decode(String.self, forKey: .scrapingStatus)
        guard let status = ScrapingStatus(rawValue: scrapingStatusString) else { fatalError("Cannot parse ScrapingStatus \(scrapingStatusString)") }
        scrapingStatus = status
    }
}
