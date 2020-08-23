//
//  InsuranceCredentialService.swift
//  Holk
//
//  Created by 张梦皓 on 2020-04-28.
//  Copyright © 2020 Holk. All rights reserved.
//

import Combine
import Foundation

final class InsuranceCredentialService {
    private let client: APIClient
    private let user: User

    private var authorizationBearerHeader: [String: String] {
        user.session?.accessToken.flatMap { return ["Authorization": "Bearer " + $0] } ?? [:]
    }

    init(client: APIClient, user: User) {
        self.client = client
        self.user = user
    }

    func fetchInsuranceStatus(_ sessionId: String) -> AnyPublisher<ScrapingStatusResponse, APIError> {
        return client
            .httpRequest(
                method: .get,
                url: Endpoint.scrapingStatus.url([sessionId]),
                headers: authorizationBearerHeader
            )
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func integrateInsurance(providerName: String) -> AnyPublisher<IntegrateInsuranceResponse, APIError> {
        return client
            .httpRequest(
                method: .post,
                url: Endpoint.addInsurance.url([providerName]),
                headers: authorizationBearerHeader
            )
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
