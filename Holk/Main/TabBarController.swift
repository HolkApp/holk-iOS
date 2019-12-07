//
//  TabBarController.swift
//  Holk
//
//  Created by 张梦皓 on 2019-04-30.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    // MARK: - Public variables
    weak var coordinator: SessionCoordinator?
    
    // MARK: - Private variables
    private let insuranceCoordinator = InsuranceCoordinator(navController: UINavigationController())
    private let protectionCoordinator = InsuranceProtectionCoordinator(navController: UINavigationController())
    
    override func viewDidLoad() {
        insuranceCoordinator.start()
        insuranceCoordinator.delegate = self
        protectionCoordinator.start()
        viewControllers = [
            insuranceCoordinator.navController,
            protectionCoordinator.navController
        ]
        
        tabBar.barTintColor = Color.tabbarBackgroundColor
    }
}

// TODO: Change this when have a real profile
extension TabBarController: InsuranceCoordinatorDelegate {
    func logout(_ coordinator: InsuranceCoordinator) {
        self.coordinator?.logout()
    }
}
