//
//  UserStore.swift
//  Holk
//
//  Created by 张梦皓 on 2020-04-24.
//  Copyright © 2020 Holk. All rights reserved.
//

import Foundation
import Combine

final class UserStore {
    private let userService: UserService
    private let authenticationStore: AuthenticationStore
    private var cancellables = Set<AnyCancellable>()
    private var user: User

    init(queue: DispatchQueue, user: User, authenticationStore: AuthenticationStore) {
        self.user = user
        self.userService = UserService(client: APIClient(queue: queue), user: user)
        self.authenticationStore = authenticationStore
    }

    func userInfo(completion: @escaping (Result<User, APIError>) -> Void = { _ in }) {
        userService.fetchUserInfo()
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .finished:
                    break
                }
            }) { [weak self] in
                guard let self = self else { return }
                self.user.userInfoResponse = $0
                completion(.success(self.user))
            }
            .store(in: &cancellables)
    }

    func addEmail(_ email: String, completion: @escaping (Result<Void, APIError>) -> Void) {
        userService.addEmail(email)
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .finished:
                    break
                }
            }) { _ in completion(.success) }
            .store(in: &cancellables)
    }

    func cancelAll() {
        cancellables.forEach { $0.cancel() }
    }
}
