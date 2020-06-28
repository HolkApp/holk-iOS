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
    private var cancellables = Set<AnyCancellable>()
    private var user: User

    init(queue: DispatchQueue, user: User) {
        self.user = user
        self.userService = UserService(client: APIClient(queue: queue), user: user)
    }

    func userInfo(completion: @escaping (Result<UserInfoResponse, APIError>) -> Void = { _ in }) {
        userService.fetchUserInfo().mapError { APIError(urlError: $0) }
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .finished:
                    break
                }
            }) { [weak self] in
                self?.user.userInfoResponse = $0
                completion(.success($0))
            }
            .store(in: &cancellables)
    }

    func addEmail(_ email: String, completion: @escaping (Result<Void, APIError>) -> Void) {
        userService.addEmail(email).mapError { APIError(urlError: $0) }
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
