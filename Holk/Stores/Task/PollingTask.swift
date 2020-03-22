//
//  PollingTask.swift
//  Holk
//
//  Created by 张梦皓 on 2020-01-14.
//  Copyright © 2020 Holk. All rights reserved.
//

import Foundation
import RxSwift

private var retryInterval: Int = 1

final class ScrapingStatusPollingTask {

    func poll<T: Codable, E: Error>(_ observable: Observable<Result<T, E>>, pollingUntil: @escaping (Result<T, E>) -> Bool) -> Observable<Result<T, E>> {
        let timer = Observable<Int>.timer(.seconds(retryInterval), scheduler: MainScheduler.instance)
        // 3. Interval subscription
        let subscription = timer.flatMapLatest { index in
            observable
        }.takeUntil(.inclusive, predicate: pollingUntil)
        return subscription
    }
}

extension ObservableType {
    func badNetworkRetrier(_ maxAttemptCount: Int = Int.max,
                 shouldRetry: @escaping (Error) -> Bool = { ($0 as NSError).code == -1005 }) -> Observable<Element> {
        return retryWhen { (errors: Observable<Error>) in
            return errors.enumerated().flatMap { attempt, error -> Observable<Void> in
                guard shouldRetry(error), maxAttemptCount > attempt + 1 else {
                    return .error(error)
                }

                let timer = Observable<Int>.timer(
                    RxTimeInterval.seconds(retryInterval),
                    scheduler: MainScheduler.instance
                ).map { _ in () } // cast to Observable<Void>

                return timer
            }
        }
    }
}
