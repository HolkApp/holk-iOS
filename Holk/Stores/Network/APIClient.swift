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
        encodeParameters: [String: String]? = nil) -> AnyPublisher<T, APIError> {

        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!

        guard let url = urlComponents.url else {
            return Fail(error: APIError(code: .badURL)).eraseToAnyPublisher()
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
            .mapError(APIError.init(urlError: ))
            .flatMap(maxPublishers: .max(1)) { pair in
                self.decode(pair.data, response: pair.response)
            }
            .eraseToAnyPublisher()
            .subscribe(on: queue)
            .eraseToAnyPublisher()
    }

    private func decode<T: Decodable>(_ data: Data, response: URLResponse) -> AnyPublisher<T, APIError> {
        guard let httpResponse = response as? HTTPURLResponse else {
            let urlError = URLError(.badServerResponse)
            return Fail(error: APIError(urlError: urlError)).eraseToAnyPublisher()
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.yyyyMMddDateFormatter)

        guard (200...299).contains(httpResponse.statusCode) else {
            do {
               var apiError = try decoder.decode(APIError.self, from: data)
                apiError.errorCode = httpResponse.statusCode
                return Fail(error: apiError).eraseToAnyPublisher()
            } catch {
                let urlError = URLError(.init(rawValue: httpResponse.statusCode))
                let apiError = APIError(urlError: urlError)
                return Fail(error: apiError).eraseToAnyPublisher()
            }
        }
        if let data = data as? T {
            return Just(data)
                .mapError { _ in APIError(code: .cannotDecodeRawData) }
                .eraseToAnyPublisher()
        } else {
            return Just(data)
                .decode(type: T.self, decoder: decoder)
                .mapError { _ in
                    var apiError = APIError(code: .cannotDecodeRawData)
                    apiError.debugMessage = "JSON could not be encoded"
                    return apiError
            }
                .eraseToAnyPublisher()
        }
    }
}
