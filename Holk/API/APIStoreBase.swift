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
    
    private let sessionManager = Alamofire.SessionManager(configuration: .default)
    
    func httpRequest<Value: Codable>(method: Alamofire.HTTPMethod, url: URL, headers: [String: String]?, parameters: [String: AnyObject]?) -> Observable<Result<Value>> {
        
        let encoding: Alamofire.ParameterEncoding = (method == .get ? URLEncoding.default : JSONEncoding.default)
        
        var httpHeaders = [String: String]()
        if let headers = headers {
            httpHeaders = headers
        }
        httpHeaders["Content-Type"] = "application/json"
        httpHeaders["Accept"] = "application/json"
        
        let requestObservable = sessionManager.rx.request(method, url, parameters: parameters, encoding: encoding, headers: headers)
        let dataObservable = requestObservable.flatMap {
            $0.rx.responseData()
            }.map({ (response, data) -> Result<Value> in
                if !(200..<300 ~= response.statusCode) {
                    throw NSError(domain: "Qliro", code: response.statusCode)
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
}
