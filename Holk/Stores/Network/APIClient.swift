//
//  APIPublisher.swift
//  Holk
//
//  Created by 张梦皓 on 2020-04-22.
//  Copyright © 2020 Holk. All rights reserved.
//

import Foundation
import Combine

enum APIMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case put = "PUT"
}

class APIClient {
    private let session = URLSession.shared
    private let queue: DispatchQueue

    init(queue: DispatchQueue) {
        self.queue = queue
    }

    func httpRequest<T: Codable>(
        method: APIMethod,
        url: URL,
        headers: [String: String] = [:],
        body: Data? = nil,
        encodeParameters: [String: String]? = nil) -> AnyPublisher<T, URLError> {

        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!

        guard let url = urlComponents.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)

        request.httpMethod = method.rawValue

        for header in headers {
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }

        if let encodeParameters = encodeParameters {
            request.encodeParameters(parameters: encodeParameters)
        } else if let body = body {
            request.httpBody = body
        }

        return session.dataTaskPublisher(for: request)
            .mapError({ $0 as URLError })
            .flatMap(maxPublishers: .max(1)) { pair in
                self.decode(pair.data)
            }
            .subscribe(on: queue)
            .eraseToAnyPublisher()
    }

    private func decode<T: Decodable>(_ data: Data) -> AnyPublisher<T, URLError> {
        if let data = data as? T {
            return Just(data)
                    .mapError { _ in URLError(.cannotDecodeRawData) }
                    .eraseToAnyPublisher()
        } else {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            return Just(data)
                .decode(type: T.self, decoder: decoder)
                .mapError { error in
                    print(error)
                    return URLError(.cannotDecodeRawData)
                }
                .eraseToAnyPublisher()
        }
    }
}
