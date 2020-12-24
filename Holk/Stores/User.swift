//
//  User.swift
//  Holk
//
//  Created by 张梦皓 on 2019-05-05.
//  Copyright © 2019 Holk. All rights reserved.
//

import Foundation

final class User {
    init() {
        session = Session()
    }

    var session: Session?
    var userInfoResponse: UserInfoResponse?

    var isNewUser: Bool {
        session?.isNewUser ?? false
    }

    var userName: String {
        userInfoResponse?.fullName ?? String()
    }

    var givenName: String {
        userInfoResponse?.givenName ?? String()
    }

    var surName: String {
        userInfoResponse?.surName ?? String()
    }
    
    var userID: String {
        userInfoResponse?.userId ?? String()
    }

    var email: String {
        userInfoResponse?.email ?? String()
    }

    var personalNumber: String {
        userInfoResponse?.personalNumber ?? String()
    }

    func reset() {
        session?.reset()
        userInfoResponse = nil
    }
}
