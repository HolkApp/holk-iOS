//
//  AuthenticationService.swift
//  Holk
//
//  Created by 张梦皓 on 2020-04-22.
//  Copyright © 2020 Holk. All rights reserved.
//

import Foundation
import Combine

final class AuthenticationService {
    private let client: APIClient

    private struct Constants {
        static let basicAuthUsername = "SampleClientId"
        static let basicAuthPassword = "secret"
    }

    private var authorizationBasicHeader: [String: String] {
        // Use the basic auth for /authorize/oauth/token, public endpoint
        let authString = "\(Constants.basicAuthUsername):\(Constants.basicAuthPassword)"
        let authData = authString.data(using: String.Encoding.utf8)!
        let base64AuthString = authData.base64EncodedString()
        return ["Authorization": "Basic " + base64AuthString]
    }

    init(client: APIClient) {
        self.client = client
    }

    func authenticate() -> AnyPublisher<BankIDAuthenticationResponse, APIError> {
        return client
            .httpRequest(method: .post, url: Endpoint.authenticate.url, headers: authorizationBasicHeader)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func token(orderRef: String) -> AnyPublisher<OAuthAuthenticationResponse, APIError> {
        var httpHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]

        httpHeaders.merge(authorizationBasicHeader) { (_, new) -> String in
            return new
        }

        let postParams = [
            "grantType": "bank_id",
            "orderRef": orderRef
        ]

        return client
            .httpRequest(method: .post, url: Endpoint.token.url, headers: authorizationBasicHeader, encodeParameters: postParams)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func refresh(refreshToken: String) -> AnyPublisher<OAuthAuthenticationResponse, APIError> {
        var httpHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        httpHeaders.merge(authorizationBasicHeader) { (_, new) -> String in
            return new
        }

        let postParams = [
            "grantType": "refresh_token",
            "refreshToken": refreshToken
        ]

        return client
            .httpRequest(method: .post, url: Endpoint.token.url, headers: httpHeaders, encodeParameters: postParams)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
