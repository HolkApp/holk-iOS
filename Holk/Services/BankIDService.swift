//
//  BankIDService.swift
//  Holk
//
//  Created by 张梦皓 on 2019-10-12.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

final class BankIDService {
    static func autostart(token: String, redirectLink: String, successHandler: @escaping () -> Void, failureHandler: @escaping () -> Void) {
        guard let url = URL(string: "bankid:///?autostartToken=\(token)&redirect=\(redirectLink)") else { return failureHandler() }
        start(url, successHandler, failureHandler)
    }
    
    static func sign(redirectLink: String, successHandler: @escaping () -> Void, failureHandler: @escaping () -> Void) {
        guard let url = URL(string: "bankid:///?redirect=\(redirectLink)") else { return failureHandler() }
        start(url, successHandler, failureHandler)
    }
    
    private static func start(_ url: URL, _ successHandler: @escaping () -> Void, _ failureHandler: @escaping () -> Void) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:]) { success in
                if success {
                    successHandler()
                } else {
                    failureHandler()
                }
            }
        } else {
            failureHandler()
        }
    }
}
