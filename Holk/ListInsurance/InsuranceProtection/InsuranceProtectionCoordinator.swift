//
//  InsuranceProtectionCoordinator.swift
//  Holk
//
//  Created by 张梦皓 on 2019-06-16.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

final class InsuranceProtectionCoordinator {
    // MARK: - Public Properties
    let navController = UINavigationController()
    // MARK: - Init
    init() {
        // TODO: Configure this
    }
    // MARK: - Public Methods
    func start() {
        let vc = InsuranceProtectionViewController()
        vc.coordinator = self
        navController.tabBarItem = UITabBarItem(title: "Ditt skydd", image: UIImage.gap, selectedImage: UIImage(systemName: "bell.fill"))
        navController.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navController.navigationBar.shadowImage = UIImage()
        navController.pushViewController(vc, animated: true)
    }
}
