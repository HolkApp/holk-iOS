//
//  PollingTask.swift
//  Holk
//
//  Created by 张梦皓 on 2020-01-14.
//  Copyright © 2020 Holk. All rights reserved.
//

import Foundation
import RxSwift

final class ScrapingStatusPollingTask {
    private var retryInterval: Int = 2
    func poll<T: Codable, E: Error>(_ observable: Observable<Result<T, E>>, pollingUntil: @escaping (Result<T, E>) -> Bool) -> Observable<Result<T, E>> {
        let interval = Observable<Int>.interval(.seconds(retryInterval), scheduler: MainScheduler.instance)
        // 3. Interval subscription
        let subscription = interval.flatMapLatest { index in
            observable
        }.takeUntil(.inclusive, predicate: pollingUntil)
        return subscription
    }
}
