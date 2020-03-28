//
//  UserResponse.swift
//  Holk
//
//  Created by 张梦皓 on 2020-03-26.
//  Copyright © 2020 Holk. All rights reserved.
//

import Foundation

struct UserInfoResponse: Codable {
    let email: String
    let fullName: String
    let givenName: String
    let surName: String
    let userId: String
    let personalNumber: String
}
