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
    var insuranceStatus = PassthroughSubject<Result<ScrapingStatusResponse.ScrapingStatus, APIError>, Never>()
    @Published var aggregatedInsuranceIds: [Insurance.ID] = []
    @Published var insuranceList: [Insurance] = []

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
            .sink(receiveCompletion: { result in
                if case let .failure(error) = result {
                    integrationHandler(.failure(error))
                }
            }, receiveValue: { sessionIDResponse in
                integrationHandler(.success(sessionIDResponse))
            })
            .store(in: &cancellables)
    }

    func allInsurances(completion: @escaping (Result<[Insurance], APIError>) -> Void = { _ in }) {
        insuranceService
            .fetchAllInsurances()
            .sink(receiveCompletion: { result in
                if case let .failure(error) = result {
                    completion(.failure(error))
                }
            }) { [weak self] allInsuranceResponse in
                self?.insuranceList = allInsuranceResponse.insuranceList
                completion(.success(allInsuranceResponse.insuranceList))
        }.store(in: &cancellables)
    }

    func pollInsuranceStatus(_ sessionID: String) {
        getInsuranceStatus(sessionID)
            .sink(
                receiveCompletion: { [weak self] result in
                    if case let .failure(error) = result {
                        self?.insuranceStatus.send(.failure(error))
                    }
                }
            ) { [weak self] scrapingStatusResponse in
                if scrapingStatusResponse.scrapingStatus != .completed && scrapingStatusResponse.scrapingStatus != .failed {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self?.pollInsuranceStatus(sessionID)
                    }
                } else {
                    if let aggregatedInsurancesIds = scrapingStatusResponse.aggregatedInsurances {
                        self?.aggregatedInsuranceIds = aggregatedInsurancesIds
                    }
                }
                self?.insuranceStatus.send(.success(scrapingStatusResponse.scrapingStatus))
        }
        .store(in: &cancellables)
    }

    private func getInsuranceStatus(_ sessionID: String) -> AnyPublisher<ScrapingStatusResponse, APIError> {
        return insuranceCredentialService
            .fetchInsuranceStatus(sessionID)
            .eraseToAnyPublisher()
    }

    func cancelAll() {
        cancellables.forEach { $0.cancel() }
    }
}

extension InsuranceStore {
    // TODO: Update the logic when the backend is ready
    func relatedInsurances(thinkOf: ThinkOfSuggestion) -> [Insurance] {
        return insuranceList.filter { insurance in
            insurance.subInsurances.contains { subInsurance in
                subInsurance.kind == .child
            }
        }
    }
}
