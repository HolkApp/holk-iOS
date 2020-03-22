//
//  BankIDAuthenticationResponse.swift
//  Holk
//
//  Created by 张梦皓 on 2019-12-31.
//  Copyright © 2019 Holk. All rights reserved.
//

import Foundation

struct BankIDAuthenticationResponse: Codable {
    let autoStartToken: String
    let orderRef: String
}
