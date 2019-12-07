//
//  User.swift
//  Holk
//
//  Created by 张梦皓 on 2019-05-05.
//  Copyright © 2019 Holk. All rights reserved.
//

import Foundation

private let kHolkAccountName = "holk.token"
private let kHolkServiceAccessToken = "access.token"
private let kHolkServiceRefreshToken = "refresh.token"

class User {
    var loginToken: LoginToken? {
        didSet {
            if let loginToken = loginToken {
                accessToken = loginToken.accessToken
                refreshToken = loginToken.refreshToken
            }
        }
    }
    
    private var _accessToken: String?
    private var _refreshToken: String?
    
    private(set) var accessToken: String? {
        get {
            if _accessToken == nil {
                _accessToken = KeychainService.get(account: kHolkAccountName, service: kHolkServiceAccessToken)
            }
            return _accessToken
        }
        set {
            if let token = newValue, !token.isEmpty {
                KeychainService.set(password: token, account: kHolkAccountName, service: kHolkServiceAccessToken)
            } else {
                KeychainService.delete(account: kHolkAccountName, service: kHolkServiceAccessToken)
                _accessToken = nil
            }
        }
    }
    
    private(set) var refreshToken: String? {
        get {
            if _refreshToken == nil {
                _refreshToken = KeychainService.get(account: kHolkAccountName, service: kHolkServiceRefreshToken)
            }
            return _refreshToken
        }
        set {
            if let token = newValue, !token.isEmpty {
                KeychainService.set(password: token, account: kHolkAccountName, service: kHolkServiceAccessToken)
            } else {
                KeychainService.delete(account: kHolkAccountName, service: kHolkServiceRefreshToken)
                _refreshToken = nil
            }
        }
    }
    
    func reset() {
        accessToken = nil
        refreshToken = nil
    }
}
