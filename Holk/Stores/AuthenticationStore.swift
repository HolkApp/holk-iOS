//
//  AuthenticationStore.swift
//  Holk
//
//  Created by 张梦皓 on 2019-10-11.
//  Copyright © 2019 Holk. All rights reserved.
//

import Foundation
import Combine

final class AuthenticationStore {
    private let user: User
    private let authenticationService: AuthenticationService
    private var cancellables = Set<AnyCancellable>()
    
    init(queue: DispatchQueue, user: User) {
        let client = APIClient(queue: queue)
        self.authenticationService = AuthenticationService(client: client)
        self.user = user
    }

    func authenticate(completion: @escaping (Result<BankIDAuthenticationResponse, APIError>) -> Void) {
        return authenticationService.authenticate()
            .mapError { APIError(urlError: $0) }
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .finished:
                    break
                }
            }) { completion(.success($0)) }
            .store(in: &cancellables)
    }

    func token(orderRef: String, completion: @escaping (Result<OauthAuthenticationResponse, APIError>) -> Void) {
        return authenticationService.token(orderRef: orderRef)
            .mapError { APIError(urlError: $0) }
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .finished:
                    break
                }
            }) { [weak self] oauthAuthenticationResponse in
                self?.user.session = Session(oauthAuthenticationResponse: oauthAuthenticationResponse)
                completion(.success(oauthAuthenticationResponse)) }
            .store(in: &cancellables)
    }
    
    func refresh(completion: @escaping (Result<OauthAuthenticationResponse, APIError>) -> Void) {
        guard let refreshToken = user.session?.refreshToken else {
            completion(.failure(.response(error: .init(.badURL))))
            return
        }

        authenticationService.refresh(refreshToken: refreshToken)
            .mapError { APIError(urlError: $0) }
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .failure(let error):
                    self?.user.reset()
                    completion(.failure(error))
                case .finished:
                    break
                }
            }) { [weak self] oauthAuthenticationResponse in
                self?.user.session = Session(oauthAuthenticationResponse: oauthAuthenticationResponse)
                completion(.success(oauthAuthenticationResponse)) }
            .store(in: &cancellables)
    }

    func cancelAll() {
        cancellables.forEach { $0.cancel() }
    }
}
