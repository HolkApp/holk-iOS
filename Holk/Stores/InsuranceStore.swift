//
//  InsuranceStore.swift
//  Holk
//
//  Created by 张梦皓 on 2020-02-17.
//  Copyright © 2020 Holk. All rights reserved.
//

import Alamofire
import RxSwift


final class InsuranceStore: APIStore {
    // MARK: - Private variables
    private let queue: DispatchQueue
    private let sessionStore: SessionStore
    private let bag = DisposeBag()
    
    init(queue: DispatchQueue, sessionStore: SessionStore) {
        self.queue = queue
        self.sessionStore = sessionStore
        
        super.init()
    }
    
    func getAllInsurance() {
        allInsurances().subscribe(onNext: { result in
            let text = try? result.get()
            
        }).disposed(by: bag)
    }
    
    private func allInsurances() -> Observable<Swift.Result<AllInsuranceResponse, APIError>> {
        let httpHeaders = sessionStore.authorizationHeader
        
        return httpRequest(
            method: .get,
            url: Endpoint.allInsurances.url(["name": hardCodedUserID]),
            headers: httpHeaders
        )
    }
}
