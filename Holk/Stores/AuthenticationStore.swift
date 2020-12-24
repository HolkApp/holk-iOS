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

    func token(orderRef: String, completion: @escaping (Result<OAuthAuthenticationResponse, APIError>) -> Void) {
        return authenticationService.token(orderRef: orderRef)
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .finished:
                    break
                }
            }) { [weak self] oAuthAuthenticationResponse in
                self?.user.session = User.Session(oAuthAuthenticationResponse: oAuthAuthenticationResponse)
                completion(.success(oAuthAuthenticationResponse)) }
            .store(in: &cancellables)
    }
    
    func refresh(completion: @escaping (Result<OAuthAuthenticationResponse, APIError>) -> Void) {
        guard let refreshToken = user.session?.refreshToken else {
            let urlError = URLError.init(.cannotParseResponse)
            completion(.failure(.init(urlError: urlError)))
            return
        }

        authenticationService.refresh(refreshToken: refreshToken)
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .failure(let error):
                    self?.user.reset()
                    completion(.failure(error))
                case .finished:
                    break
                }
            }) { [weak self] oAuthAuthenticationResponse in
                self?.user.session = User.Session(oAuthAuthenticationResponse: oAuthAuthenticationResponse)
                completion(.success(oAuthAuthenticationResponse)) }
            .store(in: &cancellables)
    }

    func cancelAll() {
        cancellables.forEach { $0.cancel() }
    }
}
