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
    var profile: UserProfile?

    var isNewUser: Bool {
        session?.isNewUser ?? email.isEmpty
    }

    var userName: String {
        profile?.fullName ?? String()
    }

    var givenName: String {
        profile?.givenName ?? String()
    }

    var surName: String {
        profile?.surName ?? String()
    }
    
    var userID: String {
        profile?.userId ?? String()
    }

    var email: String {
        profile?.email ?? String()
    }

    var personalNumber: String {
        profile?.personalNumber ?? String()
    }

    func reset() {
        session?.reset()
        profile = nil
    }
}
