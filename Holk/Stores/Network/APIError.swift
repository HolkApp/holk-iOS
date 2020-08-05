//
//  APIError.swift
//  Holk
//
//  Created by 张梦皓 on 2019-05-01.
//  Copyright © 2019 Holk. All rights reserved.
//

import Foundation

struct APIError: Error, Equatable {
    
    var code: URLError.Code?
    var errorCode: Int?
    var timestamp: Date?
    var message: String?
    var debugMessage: String?
}

extension APIError {
    init(urlError: URLError) {
        code = urlError.code
        errorCode = urlError.errorCode
        message = urlError.localizedDescription
    }
}
