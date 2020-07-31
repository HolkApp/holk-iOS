//
//  ProviderStore.swift
//  Holk
//
//  Created by 张梦皓 on 2019-12-08.
//  Copyright © 2019 Holk. All rights reserved.
//
import Foundation
import Combine

final class ProviderStore {
    // MARK: - Public variables
    var providerList = CurrentValueSubject<[InsuranceProvider]?, Never>(nil)
    
    // MARK: - Private variables
    private let user: User
    private let providerService: ProviderService
    private var cancellables = Set<AnyCancellable>()
    
    init(queue: DispatchQueue, user: User) {
        self.user = user
        providerService = ProviderService(client: APIClient(queue: queue), user: user)
    }

    // TODO: Update this simplify it by having return observable and keep a cache for the value.
    func fetchInsuranceProviders(completion: @escaping (Result<ProviderStatusResponse, APIError>) -> Void = { _ in }) {
        providerService.fetchInsuranceProviders().mapError { APIError(urlError: $0) }
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

    subscript(_ providerName: String) -> InsuranceProvider? {
        return providerList.value?.first(where: { $0.internalName == providerName })
    }

    func cancelAll() {
        cancellables.forEach { $0.cancel() }
    }
}
