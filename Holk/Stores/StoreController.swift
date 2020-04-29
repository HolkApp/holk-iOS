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

enum SessionState {
    case updated
    case shouldRefresh
    case newSession
}

final class StoreController {
    weak var delegate: StoreControllerDelegate?
    
    let authenticationStore: AuthenticationStore
    let insuranceProviderStore: InsuranceProviderStore
    let insuranceCredentialStore: InsuranceCredentialStore
    let userStore: UserStore
    let insuranceStore: InsuranceStore
    private(set) var user: User
    
    var sessionState: SessionState {
        guard let expirationDate = user.session?.expirationDate else { return .newSession }
        let fiveMintuesLater = Date().addingTimeInterval(300)
        switch expirationDate.compare(fiveMintuesLater) {
        case .orderedAscending:
            return .shouldRefresh
        default:
            return .updated
        }
    }

    private let queue = DispatchQueue(label: "se.holk.store.queue", qos: .utility)
    
    init() {
        user = User()

        authenticationStore = AuthenticationStore(queue: queue, user: user)
        userStore = UserStore.init(queue: queue, user: user)
        insuranceProviderStore = InsuranceProviderStore(queue: queue, user: user)
        insuranceCredentialStore = InsuranceCredentialStore(queue: queue, user: user)
        insuranceStore = InsuranceStore(queue: queue, user: user)
    }
    
    func resetSession() {
        user.reset()
    }
}
