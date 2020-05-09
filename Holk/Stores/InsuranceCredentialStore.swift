//
//  InsuranceCredentialStore.swift
//  Holk
//
//  Created by 张梦皓 on 2020-02-15.
//  Copyright © 2020 Holk. All rights reserved.
//

import Foundation
import Combine

final class InsuranceCredentialStore {
    // MARK: - Public variables
    var insuranceStatus = PassthroughSubject<ScrapingStatusResponse.ScrapingStatus, Never>()

    // MARK: - Private variables
    private let user: User
    private let insuranceCredentialService: InsuranceCredentialService
    private var cancellables = Set<AnyCancellable>()

    init(queue: DispatchQueue, user: User) {
        self.user = user
        insuranceCredentialService = InsuranceCredentialService(client: APIClient(queue: queue), user: user)
    }
    
    func addInsurance(_ provider: InsuranceProvider) {
        insuranceCredentialService
            .integrateInsurance(providerName: provider.internalName)
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .failure(let error):
                    print(error)
                    // TODO: Handle the error
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] sessionIDResponse in
                self?.pollInsuranceStatus(sessionIDResponse.scrapeSessionId.uuidString)
            })
            .store(in: &cancellables)
    }

    private func pollInsuranceStatus(_ sessionID: String) {
        getInsuranceStatus(sessionID)
            .sink(
                receiveCompletion: { [weak self] result in
                    switch result {
                    case .failure(let error):
                        // TODO: Handle the error
                        self?.insuranceStatus.send(.completed)
                        print(error)
                    case .finished:
                        break
                    }
                }
            ) { [weak self] scrapingStatusResponse in
                self?.insuranceStatus.send(scrapingStatusResponse.scrapingStatus)
                if scrapingStatusResponse.scrapingStatus != .completed {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self?.pollInsuranceStatus(sessionID)
                    }
                }
            }
            .store(in: &cancellables)
    }
        
    private func getInsuranceStatus(_ sessionID: String) -> AnyPublisher<ScrapingStatusResponse, APIError> {
        return insuranceCredentialService
            .fetchInsuranceStatus(sessionID)
            .mapError { APIError(urlError: $0) }
            .eraseToAnyPublisher()
    }
    
    private func integrateInsurance(providerName: String) -> AnyPublisher<IntegrateInsuranceResponse, APIError> {
        return insuranceCredentialService
            .integrateInsurance(providerName: providerName)
            .mapError { APIError(urlError: $0) }
            .eraseToAnyPublisher()
    }
}
