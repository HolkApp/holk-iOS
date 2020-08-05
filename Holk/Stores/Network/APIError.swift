//
//  APIError.swift
//  Holk
//
//  Created by 张梦皓 on 2019-05-01.
//  Copyright © 2019 Holk. All rights reserved.
//

import Foundation

struct APIError: Error, Equatable {
    enum Status: String, Codable {
        case ok = "200 OK"
        case created = "201 CREATED"
        case accepted = "202 ACCEPTED"
        case nonAuthoritativeInformation = "203 NON_AUTHORITATIVE_INFORMATION"
        case noContent = "204 NO_CONTENT"
        case resetContent = "205 RESET_CONTENT"
        case partialContent = "206 PARTIAL_CONTENT"
        case multiStatus = "207 MULTI_STATUS"
        case alreadyReported = "208 ALREADY_REPORTED"
        case badRequest = "400 BAD_REQUEST"
        case unauthorized = "401 UNAUTHORIZED"
        case paymentRequired = "402 PAYMENT_REQUIRED"
        case forbidden = "403 FORBIDDEN"
        case notFound = "404 NOT_FOUND"
        case methodNotAllowed = "405 METHOD_NOT_ALLOWED"
        case notAcceptable = "406 NOT_ACCEPTABLE"
        case requestTimeout = "408 REQUEST_TIMEOUT"
        case conflict = "409 CONFLICT"
        case lengthRequired = "411 LENGTH_REQUIRED"
        case preconditionFailed = "412 PRECONDITION_FAILED"
        case payloadTooLarge = "413 PAYLOAD_TOO_LARGE"
        case requestEntityTooLarge = "413 REQUEST_ENTITY_TOO_LARGE"
        case uriTooLong = "414 URI_TOO_LONG"
        case requestUriTooLong = "414 REQUEST_URI_TOO_LONG"
        case unsupportedMediaType = "415 UNSUPPORTED_MEDIA_TYPE"
        case methodFailure = "420 METHOD_FAILURE"
        case tooEarly = "425 TOO_EARLY"
        case upgradeRequired = "426 UPGRADE_REQUIRED"
        case unavailableForLegalReasons = "451 UNAVAILABLE_FOR_LEGAL_REASONS"
        case internalServerError = "500 INTERNAL_SERVER_ERROR"
        case notImplemented = "501 NOT_IMPLEMENTED"
        case badGateway = "502 BAD_GATEWAY"
        case serviceUnavailable = "503 SERVICE_UNAVAILABLE"
        case gatewayTimeout = "504 GATEWAY_TIMEOUT"
        case httpVersionNotSupported = "505 HTTP_VERSION_NOT_SUPPORTED"
        case bandwidthLimitExceeded = "509 BANDWIDTH_LIMIT_EXCEEDED"
        case notExtended = "510 NOT_EXTENDED"
        case networkAuthenticationRequired = "511 NETWORK_AUTHENTICATION_REQUIRED"
        case decodingError
        case unknown
    }
    
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
