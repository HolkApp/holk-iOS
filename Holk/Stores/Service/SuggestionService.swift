//
//  SuggestionService.swift
//  Holk
//
//  Created by 张梦皓 on 2020-06-11.
//  Copyright © 2020 Holk. All rights reserved.
//

import Combine
import Foundation

final class SuggestionService {
    private let client: APIClient
    private let user: User

    private var authorizationBearerHeader: [String: String] {
        user.session?.accessToken.flatMap { return ["Authorization": "Bearer " + $0] } ?? [:]
    }

    init(client: APIClient, user: User) {
        self.client = client
        self.user = user
    }

    func fetchAllSuggestions() -> AnyPublisher<SuggestionsListResponse, URLError> {
        var httpHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]

        httpHeaders.merge(authorizationBearerHeader) { (_, new) -> String in
            return new
        }

        return client
            .httpRequest(method: .get, url: Endpoint.allSuggestions.url, headers: httpHeaders)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
