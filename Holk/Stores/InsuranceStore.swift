//
//  InsuranceStore.swift
//  Holk
//
//  Created by 张梦皓 on 2019-12-08.
//  Copyright © 2019 Holk. All rights reserved.
//

import RxSwift
import RxRelay
import Alamofire

enum RequestState<T: Codable, U:Error> {
    case loaded(value: T)
    case loading
    case error(error: U)
}

final class InsuranceStore: APIStore {
    private let queue: DispatchQueue
    private let sessionStore: SessionStore
    private let bag = DisposeBag()
    
    var insuranceIssuerList = BehaviorRelay<RequestState<InsuranceIssuerList, APIError>>.init(value: .loading)
    
    init(queue: DispatchQueue, sessionStore: SessionStore) {
        self.queue = queue
        self.sessionStore = sessionStore
        
        super.init()
    }
    
    func loadInsuranceIssuers() {
        switch insuranceIssuerList.value {
        case .loading:
            break
        default:
            insuranceIssuerList.accept(.loading)
        }
        
        insuranceIssuers()
        .bind { [weak self] result in
            switch result {
            case .success(let list):
                self?.insuranceIssuerList.accept(.loaded(value: list))
            case .failure(let error):
                self?.insuranceIssuerList.accept(.error(error: error))
            }
        }
        .disposed(by: bag)
    }
    
    private func insuranceIssuers() -> Observable<Swift.Result<InsuranceIssuerList, APIError>> {
        let httpHeaders = sessionStore.authorizationHeader
        
        return httpRequest(
            method: .get,
            url: Endpoint.insurancesIssuers.url,
            headers: httpHeaders
        )
    }
    
    private func insuranceProviders() -> Observable<Swift.Result<InsuranceProvierList, APIError>> {
        let httpHeaders = sessionStore.authorizationHeader
        
        return httpRequest(
            method: .get,
            url: Endpoint.allInsurances.url,
            headers: httpHeaders
        )
    }
    
    
}
