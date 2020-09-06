//
//  InsuranceAggregateController.swift
//  Holk
//
//  Created by 张梦皓 on 2020-08-28.
//  Copyright © 2020 Holk. All rights reserved.
//

import Foundation

final class AggregateInsuranceTask {
    init(
        progressHandler: @escaping (_ status: Status) -> Void,
        completion: @escaping (_ result: Result<[Insurance], APIError>) -> Void) {
        self.progressHandler = progressHandler
        self.completion = completion
    }

    let progressHandler: (Status) -> Void
    let completion: (Result<[Insurance], APIError>) -> Void

    enum Status {
        case created
        case authenticating(response: IntegrateInsuranceResponse)
        case updating(status: String?)
        case aggregatingInsurances(ids: [Insurance.ID])
    }

    enum Error: Swift.Error {
        case authenticationFailed(String)

        var description: String {
            switch self {
            case .authenticationFailed(let description):
                return description
            }
        }
    }
}

extension APIError {
    init(error: AggregateInsuranceTask.Error) {
        self = APIError(errorCode: 500, timestamp: Date(), message: error.description, debugMessage: error.description)
    }
}

final class InsuranceAggregateController {
    var storeController: StoreController

    init(storeController: StoreController) {
        self.storeController = storeController
    }

    func onInsuranceAggregated(ids: [Insurance.ID], completion: @escaping (([Insurance]) -> Void)) {
        self.storeController.suggestionStore.fetchAllSuggestions()
        self.storeController.insuranceStore.allInsurances { result in
            do {
                let insuranceList = try result.get()
                let aggregatedInsurances = insuranceList.filter { ids.contains($0.id) }
                completion(aggregatedInsurances)
            } catch {
                // Handle error
            }
        }
    }
}
