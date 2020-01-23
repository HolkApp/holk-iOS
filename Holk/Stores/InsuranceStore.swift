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
    case error(_ error: U)
}

final class InsuranceStore: APIStore {
    // MARK: - Public variables
    var insuranceIssuerList = BehaviorRelay<RequestState<InsuranceIssuerList, APIError>>.init(value: .loading)
    // TODO: should be an array of insurance
    var insuranceState = BehaviorRelay<RequestState<ScrapingStatus, APIError>>.init(value: .loading)
    
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
    
    func loadInsuranceIssuers() {
        // TODO: should be able to reload the insurance issuer list
        switch insuranceIssuerList.value {
        case .loading:
            break
        default:
            insuranceIssuerList.accept(.loading)
        }
        
        getInsuranceIssuers()
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
    
    func addInsurance(issuer: InsuranceIssuer, personalNumber: String) {
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
    
    private func getInsuranceIssuers() -> Observable<Swift.Result<InsuranceIssuerList, APIError>> {
        let httpHeaders = sessionStore.authorizationHeader
        
        return httpRequest(
            method: .get,
            url: Endpoint.insurancesIssuers.url,
            headers: httpHeaders
        )
    }
    
    private func getInsuranceStatus(_ sessionId: String) -> Observable<Swift.Result<ScrapingStatusResponse, APIError>> {
        let httpHeaders = sessionStore.authorizationHeader
        
        return httpRequest(
            method: .get,
            // TODO: FIX this after update the xcode
            url: URL(string: Endpoint.baseUrl + String(format: Endpoint.scrapingStatus.rawValue, sessionId))!,
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
            // TODO: FIX this after update the xcode
            url: URL(string: Endpoint.baseUrl + String(format: Endpoint.addInsurance.rawValue, issuerName, personalNumber))!,
            encoding: URLEncoding.default,
            headers: httpHeaders
        )
    }
}
