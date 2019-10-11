//
//  APIEndpoint.swift
//  Holk
//
//  Created by 张梦皓 on 2019-10-11.
//  Copyright © 2019 Holk. All rights reserved.
//

import Foundation

var API_URL = "http://localhost:8080/"

enum Endpoint: String {
    case signup = "authorize/user/register"
    case login = "authorize/oauth/token"
    
    var url: URL {
        return URL(string: API_URL + self.rawValue)!
    }
}
