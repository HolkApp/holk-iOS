//
//  BankIDService.swift
//  Holk
//
//  Created by 张梦皓 on 2019-10-12.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

final class BankIDService {
    static func autostart(autoStart token: String, redirectLink: String, successHandler: @escaping () -> Void, failureHandler: @escaping (URL?) -> Void  = { _ in }) {
        guard !token.isEmpty else {
            return sign(redirectLink: redirectLink, successHandler: successHandler, failureHandler: failureHandler)
        }
        guard let url = URL(string: "bankid:///?autostarttoken=\(token)&redirect=\(redirectLink)") else { return failureHandler(nil)
        }
        start(url, successHandler, failureHandler)
    }
    
    static func sign(redirectLink: String, successHandler: @escaping () -> Void, failureHandler: @escaping (URL?) -> Void = { _ in }) {
        guard let url = URL(string: "bankid:///?redirect=\(redirectLink)") else { return failureHandler(nil) }
        start(url, successHandler, failureHandler)
    }
    
    private static func start(_ url: URL, _ successHandler: @escaping () -> Void, _ failureHandler: @escaping (URL?) -> Void) {
        DispatchQueue.main.async {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:]) { success in
                    if success {
                        successHandler()
                    } else {
                        failureHandler(url)
                    }
                }
            } else {
                failureHandler(url)
            }
        }
    }
}

extension BankIDService {
    static func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: .ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
}
