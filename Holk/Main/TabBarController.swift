//
//  TabBarController.swift
//  Holk
//
//  Created by 张梦皓 on 2019-04-30.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    let mainCoordinator = MainCoordinator(navController: UINavigationController())
    let protectionCoordinator = InsuranceProtectionCoordinator(navController: UINavigationController())
    
    override func viewDidLoad() {
        mainCoordinator.start()
        protectionCoordinator.start()
        viewControllers = [
            mainCoordinator.navController,
            protectionCoordinator.navController
        ]
        
        tabBar.barTintColor = Color.tabbarBackgroundColor
    }
}
