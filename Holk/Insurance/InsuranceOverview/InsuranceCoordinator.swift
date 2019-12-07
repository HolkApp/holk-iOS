//
//  InsuranceCoordinator.swift
//  Holk
//
//  Created by 张梦皓 on 2019-04-29.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

protocol InsuranceCoordinatorDelegate: AnyObject {
    func logout(_ coordinator: InsuranceCoordinator)
}

class InsuranceCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    // MARK: - Public Properties
    var navController: UINavigationController
    weak var delegate: InsuranceCoordinatorDelegate?
    // MARK: - Init
    init(navController: UINavigationController) {
        self.navController = navController
    }
    // MARK: - Public Methods
    func start() {
        let vc = StoryboardScene.InsuranceOverview.insuranceOverviewViewController.instantiate()
        let tabBarIcon = UIImage.fontAwesomeIcon(name: .clipboardList, style: .light, textColor: .systemBlue, size: FontAwesome.tabBarIconSize)
        // TODO: Change this when have a real profile
        vc.coordinator = self
        navController.tabBarItem = UITabBarItem(title: "Översikt", image: tabBarIcon, tag: 0)
        navController.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navController.navigationBar.shadowImage = UIImage()
        navController.navigationBar.tintColor = .black
        navController.delegate = self
        navController.pushViewController(vc, animated: true)
    }
    
    func logout() {
        navController.dismiss(animated: true)
        delegate?.logout(self)
    }
    
    // MARK: - UINavigationControllerDelegate
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
        // check the fromVC if it is a sepecific VC then handle the navigation back action if needed
        
    }
}
