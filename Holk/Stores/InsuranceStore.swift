//
//  InsuranceStore.swift
//  Holk
//
//  Created by 张梦皓 on 2019-12-08.
//  Copyright © 2019 Holk. All rights reserved.
//

import RxSwift
import Alamofire

protocol InsuranceClient {
    
}

final class InsuranceStore: APIStore, InsuranceClient {
    private let queue: DispatchQueue
    
    init(queue: DispatchQueue, user: User) {
        self.queue = queue
        
        super.init(user: user)
    }
    
    
    
}
