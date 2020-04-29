//
//  PollingTask.swift
//  Holk
//
//  Created by 张梦皓 on 2020-01-14.
//  Copyright © 2020 Holk. All rights reserved.
//

import Foundation
import Combine

extension AnyPublisher {
    static func poll<T: Codable>(_ publisher: AnyPublisher<T, URLError>, pollingUntil: @escaping (T) -> Bool) -> AnyPublisher<T, URLError> {
        let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        let publisher: AnyPublisher<T, URLError> = timer
            .mapError({ _ in URLError.init(.cancelled) })
            .flatMap { _ in publisher }
            .eraseToAnyPublisher()
            .mapError { error in
                timer.upstream.connect().cancel()
                return error
            }
            .eraseToAnyPublisher()
        return publisher
            .map({ value in
                if pollingUntil(value) {
                    timer.upstream.connect().cancel()
                }
                return value
            })
            .eraseToAnyPublisher()
    }
}
