//
//  UINavigationController+extension.swift
//  Holk
//
//  Created by 张梦皓 on 2020-03-12.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

extension UINavigationController {
    func popMiddleViewControllers() {
        if let first = viewControllers.first,
            let last = viewControllers.last, first != last {
            viewControllers = [first, last]
        }
    }
}
