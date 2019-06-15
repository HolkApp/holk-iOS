//
//  TabBarController.swift
//  Holk
//
//  Created by 张梦皓 on 2019-04-30.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    let main = MainCoordinator(navController: UINavigationController())
    
    override func viewDidLoad() {
        
        main.start()
        viewControllers = [main.navController]
        tabBar.barTintColor = Color.tabbarBackgroundColor
    }
}
