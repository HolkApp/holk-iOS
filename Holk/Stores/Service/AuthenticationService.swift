//
//  AuthenticationService.swift
//  Holk
//
//  Created by 张梦皓 on 2020-04-22.
//  Copyright © 2020 Holk. All rights reserved.
//

import Foundation
import Combine

class AuthenticationService {
    private let client: APIClient
    private let pollingTask: ScrapingStatusPollingTask

    private struct Constants {
        static let basicAuthUsername = "SampleClientId"
        static let basicAuthPassword = "secret"
    }

    private var authorizationBasicHeader: [String: String] {
        // Use the basic auth for /authorize/oauth/token, public endpoint
        let authString = String(format: "%@:%@", Constants.basicAuthUsername, Constants.basicAuthPassword)

//        let authString = "\(Constants.basicAuthUsername): \(Constants.basicAuthPassword)"
        let authData = authString.data(using: String.Encoding.utf8)!
        let base64AuthString = authData.base64EncodedString()
        return ["Authorization": "Basic " + base64AuthString]
    }

    init(queue: DispatchQueue) {
        self.client = APIClient(queue: queue)
        self.pollingTask = ScrapingStatusPollingTask()
    }

    func authenticate() -> AnyPublisher<BankIDAuthenticationResponse, URLError> {
        return client.httpRequest(method: .post, url: Endpoint.authenticate.url, headers: authorizationBasicHeader).receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }

    func token(orderRef: String) -> AnyPublisher<OauthAuthenticationResponse, URLError> {
        var httpHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]

        httpHeaders.merge(authorizationBasicHeader) { (_, new) -> String in
            return new
        }

        let postParams = [
            "grant_type": "bank-id",
            "order_ref": orderRef
        ]

        return client.httpRequest(method: .post, url: Endpoint.token.url, headers: httpHeaders, parameters: postParams).receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }

    func refresh(refreshToken: String) -> AnyPublisher<OauthAuthenticationResponse, URLError> {
        var httpHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        httpHeaders.merge(authorizationBasicHeader) { (_, new) -> String in
            return new
        }

        let postParams = [
            "grant_type": "refresh_token",
            "refresh_token": refreshToken
        ]

        return client.httpRequest(method: .post, url: Endpoint.token.url, headers: httpHeaders, parameters: postParams).receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
}
