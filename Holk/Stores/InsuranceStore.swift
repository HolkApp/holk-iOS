//
//  InsuranceStore.swift
//  Holk
//
//  Created by 张梦皓 on 2020-02-17.
//  Copyright © 2020 Holk. All rights reserved.
//

import Foundation
import Combine

final class InsuranceStore {
    // MARK: - Public variables
    var allInsuranceResponse = CurrentValueSubject<AllInsuranceResponse?, Never>(nil)

    // MARK: - Private variables
    private let user: User
    private let insuranceService: InsuranceService
    private var cancellables = Set<AnyCancellable>()

    init(queue: DispatchQueue, user: User) {
        self.user = user
        insuranceService = InsuranceService(client: APIClient(queue: queue), user: user)
    }

    func fetchAllInsurances(completion: @escaping (Result<AllInsuranceResponse, APIError>) -> Void) {
        insuranceService.fetchAllInsurances().mapError { APIError(urlError: $0) }
            .sink(receiveCompletion: { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .finished:
                break
            }
        }) { [weak self] allInsuranceResponse in
            self?.allInsuranceResponse.value = allInsuranceResponse
            completion(.success(allInsuranceResponse))
        }.store(in: &cancellables)
    }
}
