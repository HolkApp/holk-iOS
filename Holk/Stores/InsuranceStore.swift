//
//  InsuranceStore.swift
//  Holk
//
//  Created by 张梦皓 on 2020-02-15.
//  Copyright © 2020 Holk. All rights reserved.
//

import Foundation
import Combine

final class InsuranceStore {
    // MARK: - Public variables
    var insuranceStatus = PassthroughSubject<ScrapingStatusResponse.ScrapingStatus, Never>()
    var insuranceList = CurrentValueSubject<[Insurance], Never>([])

    // MARK: - Private variables
    private let user: User
    private let insuranceCredentialService: InsuranceCredentialService
    private let insuranceService: InsuranceService
    private var cancellables = Set<AnyCancellable>()

    init(queue: DispatchQueue, user: User) {
        self.user = user
        insuranceCredentialService = InsuranceCredentialService(client: APIClient(queue: queue), user: user)
        insuranceService = InsuranceService(client: APIClient(queue: queue), user: user)
    }

    func addInsurance(_ provider: InsuranceProvider, integrationHandler: @escaping (Result<IntegrateInsuranceResponse, APIError>) -> Void = { _ in }) {
        insuranceCredentialService
            .integrateInsurance(providerName: provider.internalName)
            .mapError { APIError(urlError: $0) }
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    integrationHandler(.failure(error))
                // TODO: Handle the error
                case .finished:
                    break
                }
            }, receiveValue: { sessionIDResponse in
                integrationHandler(.success(sessionIDResponse))
            })
            .store(in: &cancellables)
    }

    func fetchAllInsurances(completion: @escaping (Result<AllInsuranceResponse, APIError>) -> Void = { _ in }) {
        insuranceService
            .fetchAllInsurances()
            .mapError { APIError(urlError: $0) }
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .finished:
                    break
                }
            }) { [weak self] allInsuranceResponse in
                self?.insuranceList.value = allInsuranceResponse.insuranceList
                completion(.success(allInsuranceResponse))
        }.store(in: &cancellables)
    }

    func pollInsuranceStatus(_ sessionID: String) {
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
                } else {
                    if let scrapedInsurances = scrapingStatusResponse.scrapedInsurances {
                        self?.insuranceList.send(scrapedInsurances)
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
}
