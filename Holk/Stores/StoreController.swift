//
//  StoreController.swift
//  Holk
//
//  Created by 张梦皓 on 2019-04-25.
//  Copyright © 2019 Holk. All rights reserved.
//

import RxSwift
import Alamofire

final class StoreController {
    let authenticationStore: AuthenticationStore
    
    private let queue = DispatchQueue(label: "se.holk.store.controller", qos: .utility)
    
    init() {
        authenticationStore = AuthenticationStore(queue: queue)
    }
}
