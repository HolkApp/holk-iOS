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
private let kHolkServiceExpirationDate = "expiration.date"

class User {
    private let dateFormatter = DateFormatter().then {
        $0.dateFormat = "yyyy-MM-dd HH:mm:ss"
    }
    
    var oauthAuthenticationResponse: OauthAuthenticationResponse? {
        didSet {
            if let oauthAuthenticationResponse = oauthAuthenticationResponse {
                newUser = oauthAuthenticationResponse.newUser
                accessToken = oauthAuthenticationResponse.accessToken
                refreshToken = oauthAuthenticationResponse.refreshToken
                let expiresInSeconds = oauthAuthenticationResponse.expiresInSeconds
                expirationDate = Calendar.current.date(byAdding: .second, value: expiresInSeconds, to: Date())
            }
        }
    }

    var userInfoResponse: UserInfoResponse?
    
    private var _accessToken: String?
    private var _refreshToken: String?
    private var _expirationDateString: String?

    var userName: String {
        userInfoResponse?.fullName ?? String()
    }
    var givenName: String {
        userInfoResponse?.givenName ?? String()
    }
    var surName: String {
        userInfoResponse?.surName ?? String()
    }
    var userID: String {
        userInfoResponse?.userId ?? String()
    }
    var email: String {
        userInfoResponse?.email ?? String()
    }
    private(set) var newUser: Bool = true
    private(set) var expirationDate: Date? {
        get {
            if _expirationDateString == nil {
                _expirationDateString = KeychainService.get(account: kHolkAccountName, service: kHolkServiceExpirationDate)
            }
            return _expirationDateString.flatMap { dateFormatter.date(from: $0)
            }
        }
        set {
            if let date = newValue {
                let dateString = dateFormatter.string(from: date)
                KeychainService.set(password: dateString, account: kHolkAccountName, service: kHolkServiceExpirationDate)
            } else {
                KeychainService.delete(account: kHolkAccountName, service: kHolkServiceExpirationDate)
                _expirationDateString = nil
            }
        }
    }
    
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
                KeychainService.set(password: token, account: kHolkAccountName, service: kHolkServiceRefreshToken)
            } else {
                KeychainService.delete(account: kHolkAccountName, service: kHolkServiceRefreshToken)
                _refreshToken = nil
            }
        }
    }
    
    func reset() {
        userInfoResponse = nil
        oauthAuthenticationResponse = nil
        accessToken = nil
        refreshToken = nil
        expirationDate = nil
    }
}
