//
//  LoginToken.swift
//  Holk
//
//  Created by 张梦皓 on 2019-05-10.
//  Copyright © 2019 Holk. All rights reserved.
//

import Foundation

struct LoginToken: Codable {
    var access_token: String
    var refresh_token: String
    var token_type: String
    var scope: String
    var jti: String
    var expires_in: Int
}
