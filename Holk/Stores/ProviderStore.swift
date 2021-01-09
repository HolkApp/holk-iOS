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
    var providersSubject = CurrentValueSubject<[InsuranceProvider]?, Never>(nil)
    var providers: [InsuranceProvider]? {
        providersSubject.value
    }
    
    // MARK: - Private variables
    private let user: User
    private let providerService: ProviderService
    private let authenticationStore: AuthenticationStore
    private var cancellables = Set<AnyCancellable>()
    
    init(queue: DispatchQueue, user: User, authenticationStore: AuthenticationStore) {
        self.user = user
        providerService = ProviderService(client: APIClient(queue: queue), user: user)
        self.authenticationStore = authenticationStore
    }

    // TODO: Update this simplify it by having return observable and keep a cache for the value.
    func fetchInsuranceProviders(completion: @escaping (Result<ProviderStatusResponse, APIError>) -> Void = { _ in }) {
        providerService.fetchInsuranceProviders()
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .finished:
                    break
                }
            }) { [weak self] in
                completion(.success($0))
                self?.providersSubject.send($0.providerStatusList)
            }
            .store(in: &cancellables)
    }

    subscript(_ insurance: Insurance) -> InsuranceProvider? {
        return self[insurance.insuranceProviderName]
    }

    subscript(_ providerName: String) -> InsuranceProvider? {
        return providersSubject.value?.first(where: { $0.internalName == providerName })
    }

    func cancelAll() {
        cancellables.forEach { $0.cancel() }
    }
}
