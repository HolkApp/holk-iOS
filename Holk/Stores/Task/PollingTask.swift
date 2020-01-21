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
    private var retryInterval: Int = 2
    
    // TODO: Make this generic
    func poll(_ observable: Observable<Result<ScrapingStatusResponse, APIError>>) -> Observable<Result<ScrapingStatusResponse, APIError>> {
        let interval = Observable<Int>.interval(.seconds(retryInterval), scheduler: MainScheduler.instance)
        // 3. Interval subscription
        let subscription = interval.flatMapLatest { index in
            observable
        }.takeUntil(.inclusive) { scarpingResult -> Bool in
            switch scarpingResult {
            case .success(let scrapingStatusResponse):
                print(scrapingStatusResponse.scrapingStatus)
                switch scrapingStatusResponse.scrapingStatus {
                case "COMPLETED", "FAILED":
                    return true
                default:
                    return false
                }
            case .failure(let error):
                print(error)
                return true
            }
        }
        return subscription
    }
}
