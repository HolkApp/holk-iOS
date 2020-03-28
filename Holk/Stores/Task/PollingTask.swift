//
//  PollingTask.swift
//  Holk
//
//  Created by 张梦皓 on 2020-01-14.
//  Copyright © 2020 Holk. All rights reserved.
//

import Foundation
import RxSwift

let retryInterval = 1

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
