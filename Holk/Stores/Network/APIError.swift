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
    case response(error: URLError)
    case network
    
    var code: Int {
        switch self {
        case .response(let error):
            return error.errorCode
        default:
            return 500
        }
    }
}

extension APIError {
    init(urlError: URLError) {
        if urlError.code == .cannotDecodeRawData {
            self = .decodingError
        } else {
            self = .response(error: urlError)
        }
    }
}

extension APIError: Equatable {
    static func == (lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (.decodingError, .decodingError), (.network, .network):
            return true
        case (.response(let lhsCode), .response(let rhsCode)):
            return lhsCode == rhsCode
        default:
            return false
        }
    }
}
