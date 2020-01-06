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

protocol SessionStoreClient {
    func signup(username: String, password: String) -> Observable<Swift.Result<LoginToken, APIError>>
    func login(username: String, password: String) -> Observable<Swift.Result<LoginToken, APIError>>
    func refresh() -> Observable<Swift.Result<LoginToken, APIError>>
}

final class SessionStore: APIStore, SessionStoreClient {
    private struct Constants {
        static let basicAuthUsername = "SampleClientId"
        static let basicAuthPassword = "secret"
    }
    
    // MARK: Public Variables
    // TODO: Maybe use combine or Rx to remove the delegate
    weak var delegate: SessionStoreDelegate?
    
    let user: User
    
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
    
    func signup(username: String, password: String) -> Observable<Swift.Result<LoginToken, APIError>> {
        let postParams = [
            "username": username,
            "password": password
        ]
        let httpHeaders = authorizationBasicHeader
        
        let observable: Observable<Swift.Result<RegisterUserResponse, APIError>> =
            httpRequest(method: .post,
                url: Endpoint.signup.url,
                headers: httpHeaders,
                parameters: postParams as [String: AnyObject]
            )
        
        let mappedObservable = observable.flatMap { [weak self] result -> Observable<Swift.Result<LoginToken, APIError>> in
            guard let self = self else { fatalError("Self is nil") }
            switch result {
            case .success(let response):
                return self.login(username: response.userId, password: password)
            case .failure(let error):
                return .just(.failure(error))
            }
        }
        
        return mappedObservable
    }
    
    func login(username: String, password: String) -> Observable<Swift.Result<LoginToken, APIError>> {
        var httpHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        httpHeaders.merge(authorizationBasicHeader) { (_, new) -> String in
            return new
        }
        
        let postParams = [
            "grant_type": "password",
            "username": username,
            "password": password
        ]
        
        let observable: Observable<Swift.Result<LoginToken, APIError>> =
            httpRequest(
                method: .post,
                url: Endpoint.login.url,
                encoding: URLEncoding.default,
                headers: httpHeaders,
                parameters: postParams as [String: AnyObject]
            )
        
        return observable.map { [weak self] result -> Swift.Result<LoginToken, APIError> in
            if let loginToken = try? result.get() {
                self?.user.loginToken = loginToken
            }
            return result
        }
    }
    
    func refresh() -> Observable<Swift.Result<LoginToken, APIError>> {
        // TODO: Error handling for not found refresh token in device, should probably log out.
        guard let refreshToken = user.refreshToken else { return .just(.failure(.errorCode(code: 404))) }
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
        
        let observable: Observable<Swift.Result<LoginToken, APIError>> =
            httpRequest(
                method: .post,
                url: Endpoint.login.url,
                encoding: URLEncoding.default,
                headers: httpHeaders,
                parameters: postParams as [String: AnyObject]
        )
        
        return observable.map { [weak self] result -> Swift.Result<LoginToken, APIError> in
            if let loginToken = try? result.get() {
                self?.user.loginToken = loginToken
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
