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
}
