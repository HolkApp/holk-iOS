//
//  StoreController.swift
//  Holk
//
//  Created by 张梦皓 on 2019-04-25.
//  Copyright © 2019 Holk. All rights reserved.
//

import RxSwift
import Alamofire

protocol StoreControllerDelegate: AnyObject {
    func storeControllerAccessTokenUpdated()
    func storeControllerRefreshTokenExpired()
}

final class StoreController {
    weak var delegate: StoreControllerDelegate?
    
    let authenticationStore: AuthenticationStore
    let insuranceStore: InsuranceStore
    
    private let sessionStore: SessionStore
    private let queue = DispatchQueue(label: "se.holk.store.controller", qos: .utility)
    
    init() {
        sessionStore = SessionStore(queue: queue, user: User())
        authenticationStore = AuthenticationStore(queue: queue, sessionStore: sessionStore)
        insuranceStore = InsuranceStore(queue: queue, sessionStore: sessionStore)
        
        sessionStore.delegate = self
    }
    
    func resetSession() {
        sessionStore.reset()
    }
}

extension StoreController: SessionStoreDelegate {
    func sessionStoreAccessTokenUpdated() {
        delegate?.storeControllerAccessTokenUpdated()
    }
    
    func sessionStoreRefreshTokenExpired() {
        delegate?.storeControllerRefreshTokenExpired()
    }
}
