//
//  InsuranceService.swift
//  Holk
//
//  Created by 张梦皓 on 2020-04-27.
//  Copyright © 2020 Holk. All rights reserved.
//

import Foundation
import Combine

class InsuranceService {
    private let client: APIClient
    private let user: User

    private var authorizationBearerHeader: [String: String] {
        user.session?.accessToken.flatMap { return ["Authorization": "Bearer " + $0] } ?? [:]
    }

    init(client: APIClient, user: User) {
        self.client = client
        self.user = user
    }

    func fetchAllInsurances() -> AnyPublisher<AllInsuranceResponse, URLError> {
        var httpHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]

        httpHeaders.merge(authorizationBearerHeader) { (_, new) -> String in
            return new
        }

        return client.httpRequest(method: .get, url: Endpoint.allInsurances.url, headers: httpHeaders)
    }
}
