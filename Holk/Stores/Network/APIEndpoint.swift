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
    
    case signup = "authorize/user/register"
    case login = "authorize/oauth/token"
    case insurancesIssuers = "insurance/scraping/provider/status"
    case allInsurances = "insurance/insurance/"
    case addInsurance = "insurance/scraping/%@/ssn/%@/scrape"
    case scrapingStatus = "insurance/scraping/status/id/%@"
    
    var url: URL {
        return URL(string: Endpoint.baseUrl + self.rawValue)!
    }
    
    func url(_ arguments: [String]) -> URL {
        let string = String(format: Endpoint.baseUrl + self.rawValue, arguments: arguments)
        return URL(string: string)!
    }
}
