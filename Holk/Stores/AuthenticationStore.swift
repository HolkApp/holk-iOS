//
//  AuthenticationStore.swift
//  Holk
//
//  Created by 张梦皓 on 2019-10-11.
//  Copyright © 2019 Holk. All rights reserved.
//

import RxSwift
import Alamofire

let hardCodedUserID = "e146f083-fd5a-4a3a-ba2f-3313139ef738"
let hardCodedPassword = "1"

final class AuthenticationStore: APIStore {
    private let queue: DispatchQueue
    private let sessionStore: SessionStore
    
    init(queue: DispatchQueue, sessionStore: SessionStore) {
        self.queue = queue
        self.sessionStore = sessionStore
        
        super.init()
    }
    
    func signup(username: String, password: String) -> Observable<Swift.Result<Void, APIError>> {
        sessionStore.signup(username: username, password: password).map { result -> Swift.Result<Void, APIError> in
            switch result {
            case .success:
                return .success(())
            case .failure(let error):
                return .failure(error)
            }
        }
    }
    
    func login(username: String, password: String) -> Observable<Swift.Result<Void, APIError>> {
        return sessionStore.login(username: hardCodedUserID, password: hardCodedPassword).map { result -> Swift.Result<Void, APIError> in
            switch result {
            case .success:
                return .success(())
            case .failure(let error):
                return .failure(error)
            }
        }
    }
    
    func refresh() -> Observable<Swift.Result<Void, APIError>> {
        return sessionStore.refresh().map { result -> Swift.Result<Void, APIError> in
            switch result {
            case .success:
                return .success(())
            case .failure(let error):
                return .failure(error)
            }
        }
    }
}
