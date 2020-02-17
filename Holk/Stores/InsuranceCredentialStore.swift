//
//  InsuranceCredentialStore.swift
//  Holk
//
//  Created by 张梦皓 on 2020-02-15.
//  Copyright © 2020 Holk. All rights reserved.
//

import RxSwift
import Alamofire
import RxRelay

final class InsuranceCredentialStore: APIStore {
    // MARK: - Public variables
    // TODO: should be an array of insurance
    var insuranceState = BehaviorRelay<RequestState<ScrapingStatus, APIError>>.init(value: .unintiated)
    
    // MARK: - Private variables
    private let queue: DispatchQueue
    private let sessionStore: SessionStore
    private let bag = DisposeBag()
    private let pollingTask: ScrapingStatusPollingTask
    
    init(queue: DispatchQueue, sessionStore: SessionStore) {
        self.queue = queue
        self.sessionStore = sessionStore
        self.pollingTask = ScrapingStatusPollingTask()
        
        super.init()
    }
    
    func addInsurance(issuer: InsuranceIssuer, personalNumber: String) {
        insuranceState.accept(.loading)
        integrateInsurance(issuerName: "FOLKSAM", personalNumber: personalNumber)
            .map { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let sessionId):
                    self.pollingTask.poll(self.getInsuranceStatus(sessionId)) { [weak self] in
                        guard let self = self else { return true }
                        return self.insuranceStatusPollingPredicate($0)
                    }.map({ responseResult -> Swift.Result<ScrapingStatus, APIError> in
                        switch responseResult {
                        case .success(let scrapingResponse):
                            return .success(scrapingResponse.scrapingStatus)
                        case .failure(let error):
                            self.insuranceState.accept(.error(error))
                            return .failure(error)
                        }
                    }).bind(onNext: { scrapingStatus in
                        switch scrapingStatus {
                        case .success(let status):
                            if status == .completed {
                                self.insuranceState.accept(.loaded(value: status))
                            } else if status == .failed {
                                //                                self.insuranceState.accept(.error(error))
                            } else {
                                self.insuranceState.accept(.loading)
                            }
                        case .failure(let error):
                            self.insuranceState.accept(.error(error))
                        }
                    }).disposed(by: self.bag)
                case .failure(let error):
                    self.insuranceState.accept(.error(error))
                    print(error)
                }
        }
        .subscribe()
        .disposed(by: bag)
    }
    
        
    private func getInsuranceStatus(_ sessionId: String) -> Observable<Swift.Result<ScrapingStatusResponse, APIError>> {
        let httpHeaders = sessionStore.authorizationHeader
        
        return httpRequest(
            method: .get,
            url: Endpoint.scrapingStatus.url([sessionId]),
            headers: httpHeaders
        )
    }
    
    private func insuranceStatusPollingPredicate(_ scrapingStatusResult: Swift.Result<ScrapingStatusResponse, APIError>) -> Bool {
        switch scrapingStatusResult {
        case .success(let scrapingStatusResponse):
            switch scrapingStatusResponse.scrapingStatus {
            case .completed:
                return true
            case .failed:
                return true
            default:
                return false
            }
        case .failure(let error):
            insuranceState.accept(.error(error))
            return true
        }
    }
    
    private func integrateInsurance(issuerName: String, personalNumber: String) -> Observable<Swift.Result<String, APIError>> {
        let httpHeaders = sessionStore.authorizationHeader
        
        return httpRequest(
            method: .post,
            url: Endpoint.addInsurance.url([issuerName, personalNumber]),
            encoding: URLEncoding.default,
            headers: httpHeaders
        )
    }
}
