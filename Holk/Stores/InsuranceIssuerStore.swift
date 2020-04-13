//
//  InsuranceIssuerStore.swift
//  Holk
//
//  Created by 张梦皓 on 2019-12-08.
//  Copyright © 2019 Holk. All rights reserved.
//

import RxSwift
import RxRelay
import Alamofire

enum RequestState<T: Codable, U:Error> {
    case unintiated
    case loaded(value: T)
    case loading
    case error(_ error: U)
}

final class InsuranceIssuerStore: APIStore {
    // MARK: - Public variables
    var insuranceIssuerList = BehaviorRelay<RequestState<InsuranceIssuerList, APIError>>.init(value: .unintiated)
    
    // MARK: - Private variables
    private let queue: DispatchQueue
    private let sessionStore: SessionStore
    private let bag = DisposeBag()
    
    init(queue: DispatchQueue, sessionStore: SessionStore) {
        self.queue = queue
        self.sessionStore = sessionStore
        
        super.init()
    }

    // TODO: Update this simplify it by having return observable and keep a cache for the value.
    func loadInsuranceIssuers() {
        switch insuranceIssuerList.value {
        case .loading:
            return
        default:
            insuranceIssuerList.accept(.loading)
        }
        
        getInsuranceIssuers()
            .catchErrorJustReturn(.failure(.network))
            .bind { [weak self] result in
                switch result {
                case .success(let list):
                    self?.insuranceIssuerList.accept(.loaded(value: list))
                case .failure(let error):
                    self?.insuranceIssuerList.accept(.error(error))
                }
            }
            .disposed(by: bag)
    }
    
    private func getInsuranceIssuers() -> Observable<Swift.Result<InsuranceIssuerList, APIError>> {
        let httpHeaders = sessionStore.authorizationHeader
        
        return httpRequest(
            method: .get,
            url: Endpoint.insurancesIssuers.url,
            headers: httpHeaders
        )
    }
}
