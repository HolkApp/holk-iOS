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
    // MARK: - Public variables
    var insuranceIssuerList = BehaviorRelay<RequestState<InsuranceIssuerList, APIError>>.init(value: .loading)
    
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
    
    func addInsurance(issuer: InsuranceIssuer, personalNumber: String) {
        addInsurance(issuerName: "FOLKSAM", personalNumber: personalNumber)
            .subscribe { result in
                switch result {
                case .next(let value):
                    self.pollingTask.poll(self.insuranceStatus(sessionId: "123")).subscribe().disposed(by: self.bag)
                case .error(let error):
                    print(error)
                case .completed:
                    break
                }
        }.disposed(by: bag)
    }
    
    private func insuranceIssuers() -> Observable<Swift.Result<InsuranceIssuerList, APIError>> {
        let httpHeaders = sessionStore.authorizationHeader
        
        return httpRequest(
            method: .get,
            url: Endpoint.insurancesIssuers.url,
            headers: httpHeaders
        )
    }
    
    private func insuranceStatus(sessionId: String) -> Observable<Swift.Result<ScrapingStatusResponse, APIError>> {
        let httpHeaders = sessionStore.authorizationHeader
        
        return httpRequest(
            method: .get,
            // TODO: FIX this after update the xcode
            url: URL(string: Endpoint.baseUrl + String(format: Endpoint.scrapingStatus.rawValue, sessionId))!,
            headers: httpHeaders
        )
    }
    
    private func addInsurance(issuerName: String, personalNumber: String) -> Observable<Swift.Result<InsuranceProvierList, APIError>> {
        let httpHeaders = sessionStore.authorizationHeader
        
        return httpRequest(
            method: .post,
            url: URL(string: Endpoint.baseUrl + String(format: Endpoint.addInsurance.rawValue, issuerName, personalNumber))!,
            encoding: URLEncoding.default,
            headers: httpHeaders
        )
    }
}
