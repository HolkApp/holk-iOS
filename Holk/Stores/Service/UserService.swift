//
//  UserService.swift
//  Holk
//
//  Created by 张梦皓 on 2020-04-24.
//  Copyright © 2020 Holk. All rights reserved.
//

import Foundation
import Combine

final class UserService {
    private let client: APIClient
    private let user: User

    private var authorizationBearerHeader: [String: String] {
        user.session?.accessToken.flatMap { return ["Authorization": "Bearer " + $0] } ?? [:]
    }

    init(client: APIClient, user: User) {
        self.client = client
        self.user = user
    }

    func fetchUserInfo() -> AnyPublisher<UserInfoResponse, APIError> {
        // TODO: Do something to the header to not set in every server
        var httpHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]

        httpHeaders.merge(authorizationBearerHeader) { (_, new) -> String in
            return new
        }

        return client
            .httpRequest(method: .get, url: Endpoint.user.url, headers: httpHeaders)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func addEmail(_ email: String) -> AnyPublisher<Data, APIError> {
        var httpHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]

        httpHeaders.merge(authorizationBearerHeader) { (_, new) -> String in
            return new
        }

        let body = AddUserEmailRequest(email: email)
        let data = try? JSONEncoder().encode(body)

        return client
            .httpRequest(method: .post, url: Endpoint.addEmail.url, headers: httpHeaders, body: data)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
