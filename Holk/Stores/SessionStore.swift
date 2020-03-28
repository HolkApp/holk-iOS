//
//  SessionStore.swift
//  Holk
//
//  Created by 张梦皓 on 2019-12-23.
//  Copyright © 2019 Holk. All rights reserved.
//

import RxSwift
import Alamofire

protocol SessionStoreDelegate: AnyObject {
    func sessionStoreAccessTokenUpdated()
    func sessionStoreRefreshTokenExpired()
}

final class SessionStore: APIStore {
    private struct Constants {
        static let basicAuthUsername = "SampleClientId"
        static let basicAuthPassword = "secret"
    }
    
    // MARK: Public Variables
    // TODO: Maybe use combine or Rx to remove the delegate
    weak var delegate: SessionStoreDelegate?
    
    var user: User
    
    var authorizationHeader: [String: String] {
        authorizationBearerHeader ?? authorizationBasicHeader
    }
    
    // MARK: Private Variables
    private var authorizationBearerHeader: [String: String]? {
        user.accessToken.flatMap { return ["Authorization": "Bearer " + $0] }
    }
    
    private var authorizationBasicHeader: [String: String] {
        // Use the basic auth for /authorize/oauth/token, public endpoint
        let authString = String(format: "%@:%@", Constants.basicAuthUsername, Constants.basicAuthPassword)
        let authData = authString.data(using: String.Encoding.utf8)!
        let base64AuthString = authData.base64EncodedString()
        return ["Authorization": "Basic " + base64AuthString]
    }
    
    private let queue: DispatchQueue
    
    init(queue: DispatchQueue, user: User) {
        self.queue = queue
        self.user = user
        
        super.init()
    }

    func authenticate() -> Observable<Swift.Result<BankIDAuthenticationResponse, APIError>> {
        return httpRequest(
            method: .post,
            url: Endpoint.authenticate.url,
            headers: authorizationBasicHeader
        )
    }
    
    func token(orderRef: String) -> Observable<Swift.Result<OauthAuthenticationResponse, APIError>> {
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
        
        let observable: Observable<Swift.Result<OauthAuthenticationResponse, APIError>> =
            httpRequest(
                method: .post,
                url: Endpoint.token.url,
                encoding: URLEncoding.default,
                headers: httpHeaders,
                parameters: postParams as [String: AnyObject]
            )
        
        return observable.map { [weak self] result -> Swift.Result<OauthAuthenticationResponse, APIError> in
            if let oauthAuthenticationResponse = try? result.get() {
                self?.user.oauthAuthenticationResponse = oauthAuthenticationResponse
            }
            return result
        }
    }
    
    func refresh() -> Observable<Swift.Result<OauthAuthenticationResponse, APIError>> {
        // TODO: Error handling for not found refresh token in device, should probably log out.
        guard let refreshToken = user.refreshToken else { fatalError("Refresh token not found") }
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
        
        let observable: Observable<Swift.Result<OauthAuthenticationResponse, APIError>> = httpRequest(
                method: .post,
                url: Endpoint.token.url,
                encoding: URLEncoding.default,
                headers: httpHeaders,
                parameters: postParams as [String: AnyObject]
            )
        
        return observable.map { [weak self] result -> Swift.Result<OauthAuthenticationResponse, APIError> in
            if let oauthAuthenticationResponse = try? result.get() {
                self?.user.oauthAuthenticationResponse = oauthAuthenticationResponse
                self?.delegate?.sessionStoreAccessTokenUpdated()
            } else {
                // TODO: Only logout for now, but should only logout when receiving 401
                self?.reset()
                self?.delegate?.sessionStoreRefreshTokenExpired()
            }
            return result
        }
    }
    
    func reset() {
        user.reset()
    }
}
