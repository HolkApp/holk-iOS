//
//  APIStore.swift
//  Holk
//
//  Created by 张梦皓 on 2019-04-25.
//  Copyright © 2019 Holk. All rights reserved.
//

import RxSwift
import Alamofire

protocol APIStoreType {
    func login(username: String, password: String) -> Observable<Result<LoginToken>>
}

class APIStore: APIStoreBase, APIStoreType {
    func login(username: String, password: String) -> Observable<Result<LoginToken>> {
        var httpHeaders = [String: String]()
        
        httpHeaders["Content-Type"] = "application/x-www-form-urlencoded"
        
        let postParams = ["grant_type": "password",
                          "username": username,
                          "password": password] as [String: AnyObject]
        return httpRequest(method: .post,
                    url: URL(string: "http://localhost:8080/authorize/oauth/token")!,
                    headers: httpHeaders,
                    parameters: postParams)
    }
    
    static let sharedInstance = APIStore()
    private override init() { super.init() }
}
