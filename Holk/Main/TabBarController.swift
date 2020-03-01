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
    private let insuranceCoordinator: InsuranceCoordinator
    private let protectionCoordinator: InsuranceProtectionCoordinator
    private var storeController: StoreController

    init(storeController: StoreController) {
        self.storeController = storeController
        insuranceCoordinator = InsuranceCoordinator(navController: UINavigationController(), storeController: storeController)
        protectionCoordinator = InsuranceProtectionCoordinator(navController: UINavigationController())

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        insuranceCoordinator.start()
        insuranceCoordinator.delegate = self
        protectionCoordinator.start()
        viewControllers = [
            insuranceCoordinator.navController,
            protectionCoordinator.navController
        ]
        
        tabBar.barTintColor = Color.tabbarBackgroundColor
        tabBar.tintColor = Color.mainForegroundColor
    }
}

// TODO: Change this when have a real profile
extension TabBarController: InsuranceCoordinatorDelegate {
    func logout(_ coordinator: InsuranceCoordinator) {
        self.coordinator?.logout()
    }
}
