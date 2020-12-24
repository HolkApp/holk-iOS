//
//  StoreController.swift
//  Holk
//
//  Created by 张梦皓 on 2019-04-25.
//  Copyright © 2019 Holk. All rights reserved.
//

import Foundation

protocol StoreControllerDelegate: AnyObject {
    func storeControllerAccessTokenUpdated()
    func storeControllerRefreshTokenExpired()
}

enum SessionState {
    case updated
    case expired
    case new
}

final class StoreController {
    weak var delegate: StoreControllerDelegate?
    
    let authenticationStore: AuthenticationStore
    let providerStore: ProviderStore
    let insuranceStore: InsuranceStore
    let userStore: UserStore
    let suggestionStore: SuggestionStore
    private(set) var user: User
    
    var sessionState: SessionState {
        guard let expirationDate = user.session?.expirationDate else { return .new }
        let fiveMintuesLater = Date().addingTimeInterval(300)
        switch expirationDate.compare(fiveMintuesLater) {
        case .orderedAscending:
            return .expired
        default:
            return .updated
        }
    }

    private let queue = DispatchQueue(label: "se.holk.store.queue", qos: .utility)
    
    init() {
        user = User()

        authenticationStore = AuthenticationStore(queue: queue, user: user)
        userStore = UserStore.init(queue: queue, user: user)
        providerStore = ProviderStore(queue: queue, user: user)
        insuranceStore = InsuranceStore(queue: queue, user: user)
        suggestionStore = SuggestionStore(queue: queue, user: user)
    }
    
    func resetSession() {
        user.reset()
    }
}
