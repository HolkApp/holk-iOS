//
//  APIEndpoint.swift
//  Holk
//
//  Created by 张梦皓 on 2019-10-11.
//  Copyright © 2019 Holk. All rights reserved.
//

import Foundation

enum Endpoint: String {
    static let baseUrl = "https://dev.holk.app/"

    case authenticate = "authorize/bank-id/auth"
    case token = "authorize/oauth/token"
    case addEmail = "authorize/user/email"
    case user = "authorize/user"
    case insurancesIssuers = "insurance/scraping/provider/status"
    case allInsurances = "insurance/user"
    case addInsurance = "insurance/scraping/%@"
    case scrapingStatus = "insurance/scraping/status/id/%@"
    
    var url: URL {
        return URL(string: Endpoint.baseUrl + self.rawValue)!
    }
    
    func url(_ parameter: [String]) -> URL {
        let string = String(format: Endpoint.baseUrl + self.rawValue, arguments: parameter)
        return URL(string: string)!
    }
    
    func url(_ queryItems: [String: String]) -> URL {
        let queryItems = queryItems.map { URLQueryItem(name: $0.key, value: $0.value) }
        var urlComponent = URLComponents(string: Endpoint.baseUrl + self.rawValue)!
        urlComponent.queryItems = queryItems
        return urlComponent.url!
    }
}
