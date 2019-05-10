//
//  APIStoreBase.swift
//  Holk
//
//  Created by 张梦皓 on 2019-04-25.
//  Copyright © 2019 Holk. All rights reserved.
//

import Alamofire
import RxSwift
import RxAlamofire

class APIStoreBase {
    
    private struct Constants {
        static let basicAuthUsername = "SampleClientId"
        static let basicAuthPassword = "secret"
    }
    
    private let sessionManager = Alamofire.SessionManager(configuration: .default)
    
    func httpRequest<Value: Codable>(method: Alamofire.HTTPMethod, url: URL, headers: [String: String]?, parameters: [String: AnyObject]?) -> Observable<Result<Value>> {
        
        let encoding: Alamofire.ParameterEncoding = (method == .get ? URLEncoding.default : JSONEncoding.default)
        
        var httpHeaders = authorizationHeader
        if let headers = headers {
            headers.forEach { (key, value) in
                httpHeaders.updateValue(value, forKey: key)
            }
        }
        httpHeaders["Accept"] = "application/json"
        // TODO: Update this with correct encoding
        let requestObservable = sessionManager.rx.request(method, url, parameters: parameters, encoding: URLEncoding.default, headers: httpHeaders)
        let dataObservable = requestObservable.flatMap {
            $0.rx.responseData()
            }.map({ (response, data) -> Result<Value> in
                if !(200..<300 ~= response.statusCode) {
                    throw NSError(domain: "Holk", code: response.statusCode)
                }
                let token = response.allHeaderFields.first(where: { (key, value) -> Bool in
                    (key as? String) == "token"
                })?.value
                if let t = token {
                    // check the token, do something(refresh token)
                }
                do {
                    let data = try JSONDecoder().decode(Value.self, from: data)
                    return .success(data)
                } catch {
                    
                    return .failure(APIError.decodingError)
                }
            })
        return dataObservable
    }
    
    private var authorizationHeader: [String: String] {
        guard let token = User.sharedInstance.accessToken else {
            // Use the basic auth for /authorize/oauth/token, public endpoint
            let authString = String(format: "%@:%@", Constants.basicAuthUsername, Constants.basicAuthPassword)
            let authData = authString.data(using: String.Encoding.utf8)!
            let base64AuthString = authData.base64EncodedString()
            return ["Authorization": "Basic " + base64AuthString]
            
        }
        return ["Authorization": "Bearer " + token]
    }
}
