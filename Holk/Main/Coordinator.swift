//
//  Coordinator.swift
//  Holk
//
//  Created by 张梦皓 on 2019-10-17.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

protocol Coordinator {
    var navController: UINavigationController { get set }
    func start()
    func back()
    func popOtherViewControllers()
}

extension Coordinator {
    func back() {
        navController.popViewController(animated: true)
    }
    
    func popOtherViewControllers() {
        if let first = navController.viewControllers.first,
            let last = navController.viewControllers.last, first != last {
            navController.viewControllers = [first, last]
        }
    }
}
