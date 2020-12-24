//
//  APIError.swift
//  Holk
//
//  Created by 张梦皓 on 2019-05-01.
//  Copyright © 2019 Holk. All rights reserved.
//

import Foundation

struct APIError: Error, Equatable, Decodable {
    var errorCode: Int?
    var timestamp: Date?
    var message: String?
    var debugMessage: String?

    var localizedDescription: String {
        return message ?? debugMessage ?? "Something went wrong"
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
