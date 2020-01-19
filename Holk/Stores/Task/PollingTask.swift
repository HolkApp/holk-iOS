//
//  PollingTask.swift
//  Holk
//
//  Created by 张梦皓 on 2020-01-14.
//  Copyright © 2020 Holk. All rights reserved.
//

import Foundation
import RxSwift

class ScrapingStatusPollingTask {
    private var retryInterval: TimeInterval = 1
    
    func poll(_ observable: Observable<Result<ScrapingStatusResponse, APIError>>) -> Observable<Result<ScrapingStatusResponse, APIError>> {
        // 1. Return the Observable
        return Observable<Result<ScrapingStatusResponse, APIError>>.create { observer -> Disposable in
            // 2. We create the interval here
            let interval = Observable<Int>.interval(.seconds(5), scheduler: MainScheduler.instance)
            // 3. Interval subscription
            let subscription = interval.flatMapLatest { index in
                observable
            }.takeUntil(.inclusive) { scarpingResult -> Bool in
                switch scarpingResult {
                case .success(let scrapingStatusResponse):
                    switch scrapingStatusResponse.scrapingStatus {
                    case "COMPLETED", "FAILED":
                        return true
                    default:
                        return false
                    }
                case .failure(let error):
                    return true
                }
            }.subscribe()

            return Disposables.create {
                subscription.dispose()
            }
        }
    }
}
