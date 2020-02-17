//
//  LoginToken.swift
//  Holk
//
//  Created by 张梦皓 on 2019-05-10.
//  Copyright © 2019 Holk. All rights reserved.
//

import Foundation

struct LoginToken: Codable {
    let accessToken: String
    let refreshToken: String
    let tokenType: String
    let scope: String
    let jti: String
    let expiresInSeconds: Int
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case tokenType = "token_type"
        case scope = "scope"
        case jti = "jti"
        case expiresInSeconds = "expires_in"
    }
}

extension LoginToken {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        accessToken = try container.decode(String.self, forKey: .accessToken)
        refreshToken = try container.decode(String.self, forKey: .refreshToken)
        tokenType = try container.decode(String.self, forKey: .tokenType)
        scope = try container.decode(String.self, forKey: .scope)
        jti = try container.decode(String.self, forKey: .jti)
        expiresInSeconds = try container.decode(Int.self, forKey: .expiresInSeconds)
    }
}
