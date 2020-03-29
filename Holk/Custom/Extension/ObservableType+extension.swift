//
//  ObservableType+extension.swift
//  Holk
//
//  Created by 张梦皓 on 2020-03-26.
//  Copyright © 2020 Holk. All rights reserved.
//

import RxSwift

extension ObservableType {
    func flatMap<A: AnyObject, O: ObservableType>(weak obj: A, selector: @escaping (A, Self.Element) throws -> O) -> Observable<O.Element> {
        return flatMap { [weak obj] value -> Observable<O.Element> in
            try obj.map { try selector($0, value).asObservable() } ?? .empty()
        }
    }

    func retrier(_ maxAttemptCount: Int = Int.max,
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
