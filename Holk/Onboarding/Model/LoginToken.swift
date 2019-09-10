//
//  LoginToken.swift
//  Holk
//
//  Created by 张梦皓 on 2019-05-10.
//  Copyright © 2019 Holk. All rights reserved.
//

import Foundation

struct LoginToken: Codable {
    var accessToken: String
    var refreshToken: String
    var tokenType: String
    var scope: String
    var jti: String
    var expiresInSeconds: Int
    
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
