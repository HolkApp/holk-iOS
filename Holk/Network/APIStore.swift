//
//  APIStore.swift
//  Holk
//
//  Created by 张梦皓 on 2019-04-25.
//  Copyright © 2019 Holk. All rights reserved.
//

import Alamofire
import RxSwift
import RxAlamofire

class APIStore {
    private struct Constants {
        static let basicAuthUsername = "SampleClientId"
        static let basicAuthPassword = "secret"
    }
    
    init(user: User) {
        self.user = user
    }
    
    let user: User
    private let sessionManager = Alamofire.SessionManager(configuration: .default)
    
    func httpRequest<Value: Codable>(
        method: Alamofire.HTTPMethod,
        url: URL,
        encoding: Alamofire.ParameterEncoding? = nil,
        headers: [String: String] = ["Content-Type": "application/json"],
        parameters: [String: AnyObject]? = nil
    ) -> Observable<Swift.Result<Value?, APIError>> {
        
        let encoding: Alamofire.ParameterEncoding = encoding ?? (method == .get ? URLEncoding.default : JSONEncoding.default)
        let httpHeaders = updateHeaders(with: headers)
        
        let requestObservable = sessionManager.rx.request(method, url, parameters: parameters, encoding: encoding, headers: httpHeaders)
        let dataObservable = requestObservable.flatMap {
                $0.rx.responseData()
            }.map({ (response, data) -> Swift.Result<Value?, APIError> in
                // TODO: check the token, do something(refresh token)
//                let token = response.allHeaderFields.first(where: { (key, value) -> Bool in
//                    (key as? String) == "token"
//                })?.value
//                if let accessToken = token, let storedAccessToken = user.accessToken {
//                    if storedAccessToken != accessToken {
//                        user.accessToken = accessToken
//                    }
//                }
                if !(200..<300 ~= response.statusCode) {
                    return .failure(.errorCode(code: response.statusCode))
                }
                do {
                    guard !data.isEmpty else { return .success(.none) }
                    let data = try JSONDecoder().decode(Value.self, from: data)
                    return .success(data)
                } catch {
                    return .failure(.decodingError)
                }
            })
        return dataObservable
    }
    
    private func updateHeaders(with initialHeaders: [String: String]) -> [String: String] {
        var httpHeaders = initialHeaders.merging(authorizationHeader) { (_, new) -> String in
            return new
        }
        httpHeaders["Accept"] = "application/json"
        
        return httpHeaders
    }
    
    private var authorizationHeader: [String: String] {
        if let token = user.accessToken {
            return ["Authorization": "Bearer " + token]
        } else {
            // Use the basic auth for /authorize/oauth/token, public endpoint
            let authString = String(format: "%@:%@", Constants.basicAuthUsername, Constants.basicAuthPassword)
            let authData = authString.data(using: String.Encoding.utf8)!
            let base64AuthString = authData.base64EncodedString()
            return ["Authorization": "Basic " + base64AuthString]
        }
    }
}
