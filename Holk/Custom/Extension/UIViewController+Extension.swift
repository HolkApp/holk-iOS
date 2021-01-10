//
//  UIViewController+Extension.swift
//  Holk
//
//  Created by 张梦皓 on 2020-10-27.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

extension UIViewController {
    var statusBarHeight: CGFloat {
        UIApplication.shared.windows.first { $0.isKeyWindow }?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    }

    var navigationBarHeight: CGFloat {
        navigationController?.navigationBar.frame.height ?? 0
    }


    // TODO: RequestName For Debug only, remove it
    func showError(_ error: APIError, requestName: String = String()) {
        let alert = UIAlertController(title: requestName + (String(describing: error.errorCode)), message: error.debugMessage, preferredStyle: .alert)
        alert.addAction(.init(
            title: LocalizedString.Generic.close,
            style: .default,
            handler: { action in
                alert.dismiss(animated: true)
            })
        )

        present(alert, animated: true)
    }
}
