//
//  InsuranceProviderService.swift
//  Holk
//
//  Created by 张梦皓 on 2020-04-26.
//  Copyright © 2020 Holk. All rights reserved.
//

import Foundation
import Combine

class InsuranceProviderService {
    private let client: APIClient
    private let user: User

    private var authorizationBearerHeader: [String: String] {
        user.session?.accessToken.flatMap { return ["Authorization": "Bearer " + $0] } ?? [:]
    }

    init(client: APIClient, user: User) {
        self.client = client
        self.user = user
    }

    func fetchInsuranceProviders() -> AnyPublisher<ProviderStatusResponse, URLError> {
        return client.httpRequest(method: .get, url: Endpoint.insurancesIssuers.url, headers: authorizationBearerHeader)
    }
}
