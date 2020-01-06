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
    private let sessionManager = Alamofire.SessionManager(configuration: .default)
    
    func httpRequest<Value: Codable>(
        method: Alamofire.HTTPMethod,
        url: URL,
        encoding: Alamofire.ParameterEncoding? = nil,
        headers: [String: String] = [:],
        parameters: [String: AnyObject]? = nil
    ) -> Observable<Swift.Result<Value, APIError>> {
        
        let encoding: Alamofire.ParameterEncoding = encoding ?? (method == .get ? URLEncoding.default : JSONEncoding.default)
        let httpHeaders = updateHeaders(with: headers)
        
        let requestObservable = sessionManager.rx.request(method, url, parameters: parameters, encoding: encoding, headers: httpHeaders)
        let dataObservable = requestObservable.flatMap {
                $0.rx.responseData()
            }.map({ (response, data) -> Swift.Result<Value, APIError> in
                if !(200..<300 ~= response.statusCode) {
                    return .failure(.errorCode(code: response.statusCode))
                }
                do {
                    guard !data.isEmpty else { fatalError("Received empty response") }
                    let data = try JSONDecoder().decode(Value.self, from: data)
                    return .success(data)
                } catch {
                    return .failure(.decodingError)
                }
            })
        return dataObservable
    }
    
    private func updateHeaders(with initialHeaders: [String: String]) -> [String: String] {
        var httpHeaders = initialHeaders
        
        if httpHeaders["Content-Type"] == nil {
            httpHeaders["Content-Type"] = "application/json"
        }
        httpHeaders["Accept"] = "application/json"
        
        return httpHeaders
    }
}
