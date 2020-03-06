//
//  InsuranceStore.swift
//  Holk
//
//  Created by 张梦皓 on 2020-02-17.
//  Copyright © 2020 Holk. All rights reserved.
//

import Alamofire
import RxSwift
import RxRelay

final class InsuranceStore: APIStore {
    // MARK: - Public variables
    var allInsurance = BehaviorRelay<AllInsuranceResponse?>.init(value: nil)
    var allInsuranceResult = BehaviorRelay<RequestState<AllInsuranceResponse, APIError>>.init(value: .unintiated)
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
        switch allInsuranceResult.value {
        case .loading:
            return
        default:
            allInsuranceResult.accept(.loading)
        }
        allInsurances().subscribe(onNext: { result in
            switch result {
            case .success(let insurances):
                self.allInsurance.accept(insurances)
                self.allInsuranceResult.accept(.loaded(value: insurances))
            case .failure:
                // TODO: Error handling
                break
            }
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
