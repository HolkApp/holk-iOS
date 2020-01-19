//
//  APIEndpoint.swift
//  Holk
//
//  Created by 张梦皓 on 2019-10-11.
//  Copyright © 2019 Holk. All rights reserved.
//

import Foundation

enum Endpoint: String {
    case signup = "authorize/user/register"
    case login = "authorize/oauth/token"
    case insurancesIssuers = "insurance/scraping/provider/status"
    case allInsurances = "insurance/insurance/"
    case addInsurance = "insurance/scraping/%@/ssn/%@/scrape"
    
    var baseUrl: String {
        "https://dev.holk.app/"
    }
    
    var url: URL {
        return URL(string: baseUrl + self.rawValue)!
    }
    
    var text: String {
        return baseUrl + self.rawValue
    }
}
