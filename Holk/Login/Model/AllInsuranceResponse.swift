//
//  AllInsuranceResponse.swift
//  Holk
//
//  Created by 张梦皓 on 2020-02-17.
//  Copyright © 2020 Holk. All rights reserved.
//

import Foundation

struct AllInsuranceResponse: Codable {
    let insuranceList: [Insurance]
    let lastUpdated: Date
    
    private enum CodingKeys: String, CodingKey {
        case insuranceList = "insuranceList"
        case lastUpdated = "lastScraped"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        insuranceList = try container.decode([Insurance].self, forKey: .insuranceList)
        let lastUpdatedString = try container.decode(String.self, forKey: .lastUpdated)
        lastUpdated = DateFormatter.simpleDateFormatter.date(from: lastUpdatedString) ?? Date()
    }
}

struct Insurance: Codable {
    let id: String
//    let insuranceProvider: InsuranceIssuer
    let insuranceType: String
    let issuerReference: String
    let ssn: String
    let startDate: Date
    let endDate: Date
    let username: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
//        case insuranceProvider = "insuranceProvider"
        case insuranceType = "insuranceType"
        case issuerReference = "issuerReference"
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
        insuranceType = try container.decode(String.self, forKey: .insuranceType)
        issuerReference = try container.decode(String.self, forKey: .issuerReference)
        let startDateString = try container.decode(String.self, forKey: .startDate)
        startDate = DateFormatter.simpleDateFormatter.date(from: startDateString) ?? Date()
        let endDateString = try container.decode(String.self, forKey: .endDate)
        endDate = DateFormatter.simpleDateFormatter.date(from: endDateString) ?? Date()
        ssn = try container.decode(String.self, forKey: .ssn)
        username = try container.decode(String.self, forKey: .username)
    }
}
