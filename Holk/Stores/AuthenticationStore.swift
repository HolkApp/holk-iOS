//
//  AuthenticationStore.swift
//  Holk
//
//  Created by 张梦皓 on 2019-10-11.
//  Copyright © 2019 Holk. All rights reserved.
//

import RxSwift
import Alamofire

final class AuthenticationStore: APIStore {
    private let queue: DispatchQueue
    private let sessionStore: SessionStore
    private let pollingTask: ScrapingStatusPollingTask
    
    init(queue: DispatchQueue, sessionStore: SessionStore) {
        self.queue = queue
        self.sessionStore = sessionStore
        self.pollingTask = ScrapingStatusPollingTask()
        
        super.init()
    }

    func authenticate() -> Observable<Swift.Result<BankIDAuthenticationResponse, APIError>> {
        return sessionStore.authenticate()
    }
    
    func token(orderRef: String) -> Observable<Swift.Result<Void, APIError>> {
        return sessionStore.token(orderRef: orderRef).map { result in
            switch result {
            case .success:
                return .success
            case .failure(let error):
                return .failure(error)
            }
        }
    }
    
    func refresh() -> Observable<Swift.Result<Void, APIError>> {
        return sessionStore.refresh().map { result in
            switch result {
            case .success:
                return .success
            case .failure(let error):
                return .failure(error)
            }
        }
    }

    func userInfo() -> Observable<Swift.Result<Void, APIError>> {
        return sessionStore.userInfo().map { result in
            switch result {
            case .success:
                return .success
            case .failure(let error):
                return .failure(error)
            }
        }
    }

    func addUser(_ email: String) -> Observable<Swift.Result<Void, APIError>> {
        let postParams = ["email": email]

        let observable: Observable<Swift.Result<Data, APIError>> = httpRequest(
            method: .post,
            url: Endpoint.addEmail.url,
            headers: sessionStore.authorizationHeader,
            parameters: postParams as [String: AnyObject]
        )

        return observable.map { result in
            switch result {
            case .success:
                return .success
            case .failure(let error):
                return .failure(error)
            }
        }
    }
}
