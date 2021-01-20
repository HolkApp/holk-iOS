//
//  APIError.swift
//  Holk
//
//  Created by 张梦皓 on 2019-05-01.
//  Copyright © 2019 Holk. All rights reserved.
//

import Foundation

struct APIError: LocalizedError, Equatable, Decodable {
    var errorCode: Int?
    var timestamp: Date?
    var message: String?
    var debugMessage: String?

    var failureReason: String? {
        return message ?? "Something went wrong"
    }

    private enum CodingKeys: String, CodingKey {
        case errorCode = "errorCode"
        case message = "error_description"
        case debugMessage = "error"
        case timestamp = "timestamp"
    }
}

extension APIError {
    init(code: URLError.Code) {
        self.init(urlError: URLError(code))
    }
    
    init(urlError: URLError) {
        errorCode = urlError.errorCode
        message = urlError.localizedDescription
    }
}
