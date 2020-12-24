//
//  UserSession.swift
//  Holk
//
//  Created by 张梦皓 on 2020-12-24.
//  Copyright © 2020 Holk. All rights reserved.
//

import Foundation

extension User {
    final class Session {
        private let kHolkAccountName = "holk.token"
        private let kHolkServiceAccessToken = "access.token"
        private let kHolkServiceRefreshToken = "refresh.token"
        private let kHolkServiceExpirationDate = "expiration.date"

        init(oAuthAuthenticationResponse: OAuthAuthenticationResponse? = nil) {
            if let response = oAuthAuthenticationResponse {
                accessToken = response.accessToken
                refreshToken = response.refreshToken
                let expiresInSeconds = response.expiresInSeconds
                expirationDate = Calendar.current.date(byAdding: .second, value: expiresInSeconds, to: Date())
                isNewUser = response.newUser
            }
        }

        func reset() {
            expirationDate = nil
            accessToken = nil
            refreshToken = nil
        }

        private let dateFormatter = DateFormatter.longDateFormatter
        private var _accessToken: String?
        private var _refreshToken: String?
        private var _expirationDateString: String?

        private(set) var isNewUser: Bool = false

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
                    _expirationDateString = dateString
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
                    _accessToken = token
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
                    _refreshToken = token
                } else {
                    KeychainService.delete(account: kHolkAccountName, service: kHolkServiceRefreshToken)
                    _refreshToken = nil
                }
            }
        }
    }

}
