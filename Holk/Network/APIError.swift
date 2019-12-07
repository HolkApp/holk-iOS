//
//  APIError.swift
//  Holk
//
//  Created by 张梦皓 on 2019-05-01.
//  Copyright © 2019 Holk. All rights reserved.
//

import Foundation

enum APIError: Error {
    case decodingError
    case errorCode(code: Int)
    case network
    
    var code: Int {
        switch self {
        case let .errorCode(code):
            return code
        default:
            return 500
        }
    }
}

extension APIError: Equatable {
    static func == (lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (.decodingError, .decodingError), (.network, .network):
            return true
        case (.errorCode(let lhsCode), .errorCode(let rhsCode)):
            return lhsCode == rhsCode
        default:
            return false
        }
    }
}
