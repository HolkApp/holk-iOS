//
//  InsuranceProtectionCoordinator.swift
//  Holk
//
//  Created by 张梦皓 on 2019-06-16.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

final class InsuranceProtectionCoordinator: Coordinator {
    // MARK: - Public Properties
    var navController: UINavigationController
    // MARK: - Init
    init(navController: UINavigationController) {
        self.navController = navController
    }
    // MARK: - Public Methods
    func start() {
        let vc = StoryboardScene.InsuranceProtection.insuranceProtectionViewController.instantiate()
        vc.coordinator = self
        let tabBarIcon = UIImage.fontAwesomeIcon(name: .gameBoard, style: .light, textColor: .systemBlue, size: FontAwesome.tabBarIconSize)
        navController.tabBarItem = UITabBarItem(title: "Ditt skydd", image: tabBarIcon, tag: 1)
        navController.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navController.navigationBar.shadowImage = UIImage()
        navController.pushViewController(vc, animated: true)
    }
}
