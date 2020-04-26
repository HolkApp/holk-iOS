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
        parameters: [String: String] = [:]) -> AnyPublisher<T, URLError> {

        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!

        if !parameters.isEmpty {
            urlComponents.queryItems = []
        }

        for parameter in parameters {
            urlComponents.queryItems?.append(URLQueryItem(name: parameter.key, value: parameter.value))
        }

        guard let url = urlComponents.url else {

            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }


        var request = URLRequest(url: url)

        request.httpMethod = method.rawValue

//        for header in headers {
//            request.addValue(header.key, forHTTPHeaderField: header.value)
//        }

        return session.dataTaskPublisher(for: request)
            .mapError({ $0 as URLError })
            .flatMap(maxPublishers: .max(1)) { pair in
                self.decode(pair.data)
            }
            .subscribe(on: queue)
            .eraseToAnyPublisher()
    }

    private func decode<T: Decodable>(_ data: Data) -> AnyPublisher<T, URLError> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return Just(data)
            .decode(type: T.self, decoder: decoder)
            .mapError { _ in
                URLError(.cannotDecodeRawData)
            }
            .eraseToAnyPublisher()
    }
}
