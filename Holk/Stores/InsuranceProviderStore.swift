//
//  InsuranceProviderStore.swift
//  Holk
//
//  Created by 张梦皓 on 2019-12-08.
//  Copyright © 2019 Holk. All rights reserved.
//
import Foundation
import Combine

final class InsuranceProviderStore {
    // MARK: - Public variables
    var providerList = CurrentValueSubject<[InsuranceProvider]?, Never>(nil)
    
    // MARK: - Private variables
    private let user: User
    private let insuranceProviderService: InsuranceProviderService
    private var cancellables = Set<AnyCancellable>()
    
    init(queue: DispatchQueue, user: User) {
        self.user = user
        insuranceProviderService = InsuranceProviderService(client: APIClient(queue: queue), user: user)
    }

    // TODO: Update this simplify it by having return observable and keep a cache for the value.
    func fetchInsuranceProviders(completion: @escaping (Result<ProviderStatusResponse, APIError>) -> Void = { _ in }) {
        insuranceProviderService.fetchInsuranceProviders().mapError { APIError(urlError: $0) }
        .sink(receiveCompletion: { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .finished:
                break
            }
        }) { [weak self] in
            completion(.success($0))
            self?.providerList.send($0.providerStatusList)
        }
        .store(in: &cancellables)
    }
}
