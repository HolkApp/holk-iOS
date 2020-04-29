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
    
    func addInsurance(_ provider: InsuranceProvider, personalNumber: String) {
        insuranceCredentialService
            .integrateInsurance(providerName: "FOLKSAM", personalNumber: personalNumber)
            .flatMap { sessionID in
                AnyPublisher<ScrapingStatusResponse, URLError>
                    .poll(self.insuranceCredentialService.fetchInsuranceStatus("sessionID")) { scrapingStatusResponse -> Bool in
                    return scrapingStatusResponse.scrapingStatus == .completed
                    }
            }
            .sink(
                receiveCompletion: { [weak self] result in
                    switch result {
                    case .finished:
                        break
                    case .failure(let error):
                        // TODO:
                        print(error)
                        self?.insuranceStatus.send(.completed)
                    }
                }
            )
            { [weak self] scrapingStatusResponse in
                self?.insuranceStatus.send(scrapingStatusResponse.scrapingStatus)
            }
            .store(in: &cancellables)
    }
    
        
    private func getInsuranceStatus(_ sessionID: String) -> AnyPublisher<ScrapingStatusResponse, APIError> {
        return insuranceCredentialService
            .fetchInsuranceStatus(sessionID)
            .mapError { APIError(urlError: $0) }
            .eraseToAnyPublisher()
    }
    
    private func integrateInsurance(providerName: String, personalNumber: String) -> AnyPublisher<String, APIError> {
        return insuranceCredentialService
            .integrateInsurance(providerName: providerName, personalNumber: personalNumber)
            .mapError { APIError(urlError: $0) }
            .eraseToAnyPublisher()
    }
}
