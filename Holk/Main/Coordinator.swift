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
}

extension Coordinator {
    func back() {
        navController.popViewController(animated: true)
    }
}
