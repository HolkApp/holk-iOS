//
//  User.swift
//  Holk
//
//  Created by 张梦皓 on 2019-05-05.
//  Copyright © 2019 Holk. All rights reserved.
//

import Foundation

class User {
    private var keyChainService = KeychainService()
    
    var loginToken: LoginToken?
}
