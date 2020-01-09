//
//  APIEndpoint.swift
//  Holk
//
//  Created by 张梦皓 on 2019-10-11.
//  Copyright © 2019 Holk. All rights reserved.
//

import Foundation

var API_URL = "https://dev.holk.app/"

enum Endpoint: String {
    case signup = "authorize/user/register"
    case login = "authorize/oauth/token"
    case insurancesIssuers = "insurance/scraping/status"
    case allInsurances = "insurance/insurance/"
    case addInsurance = "insurance/scraping/%@/ssn/%@/scrape"
    
    var url: URL {
        return URL(string: API_URL + self.rawValue)!
    }
}
