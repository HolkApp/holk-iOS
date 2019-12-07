//
//  AuthenticationStore.swift
//  Holk
//
//  Created by 张梦皓 on 2019-10-11.
//  Copyright © 2019 Holk. All rights reserved.
//

import RxSwift
import Alamofire

protocol AuthenticationClient {
    func signup(username: String, password: String) -> Observable<Swift.Result<String?, APIError>>
    func login(username: String, password: String) -> Observable<Swift.Result<LoginToken?, APIError>>
}

final class AuthenticationStore: APIStore, AuthenticationClient {
    private let queue: DispatchQueue
    
    init(queue: DispatchQueue, user: User) {
        self.queue = queue
        
        super.init(user: user)
    }
    
    func signup(username: String, password: String) -> Observable<Swift.Result<String?, APIError>> {
        let postParams = [
            "username": username,
            "password": password
        ]
        
        return httpRequest(method: .post,
                           url: Endpoint.signup.url,
                           parameters: postParams as [String: AnyObject]
        )
    }
    
    func login(username: String, password: String) -> Observable<Swift.Result<LoginToken?, APIError>> {
        let httpHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let postParams = [
            "grant_type": "password",
            "username": username,
            "password": password
        ]
        return httpRequest(method: .post,
                           url: Endpoint.login.url,
                           encoding: URLEncoding.default,
                           headers: httpHeaders,
                           parameters: postParams as [String: AnyObject]
        )
    }
}
