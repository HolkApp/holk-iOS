//
//  TabBarController.swift
//  Holk
//
//  Created by 张梦皓 on 2019-04-30.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    // MARK: - Private variables
    private let insuranceCoordinator = InsuranceCoordinator(navController: UINavigationController())
    private let protectionCoordinator = InsuranceProtectionCoordinator(navController: UINavigationController())
    
    override func viewDidLoad() {
        insuranceCoordinator.start()
        protectionCoordinator.start()
        viewControllers = [
            insuranceCoordinator.navController,
            protectionCoordinator.navController
        ]
        
        tabBar.barTintColor = Color.tabbarBackgroundColor
    }
}
