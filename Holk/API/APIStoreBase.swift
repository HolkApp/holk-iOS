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
    
    func httpRequest(method: Alamofire.HTTPMethod, url: URL, headers: [String: String]?, parameters: [String: AnyObject]?) -> Observable<DataRequest> {
        
        let encoding: Alamofire.ParameterEncoding = (method == .get ? URLEncoding.default : JSONEncoding.default)
        
        var httpHeaders = [String: String]()
        if let headers = headers {
            httpHeaders = headers
        }
        httpHeaders["Content-Type"] = "application/json"
        httpHeaders["Accept"] = "application/json"
        
        let requestObservable = sessionManager.rx.request(method, url, parameters: parameters, encoding: encoding, headers: headers)
        return requestObservable.do(onNext: { (req) in
            req.responseJSON(completionHandler: { (res) in
                if let  code = req.response?.statusCode, 200...299 ~= code {
                    // Success request, update token or refresh token
                }
            })
        })
    }
}
