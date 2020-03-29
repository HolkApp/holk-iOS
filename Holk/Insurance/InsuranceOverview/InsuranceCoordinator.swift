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
    var storeController: StoreController
    weak var delegate: InsuranceCoordinatorDelegate?
    // MARK: - Init
    init(navController: UINavigationController, storeController: StoreController) {
        self.navController = navController
        self.storeController = storeController
    }
    // MARK: - Public Methods
    func start() {
        let insuranceOverviewViewController = InsuranceOverviewViewController(storeController: storeController)
        insuranceOverviewViewController.coordinator = self
        navController.tabBarItem = UITabBarItem(title: "Översikt", image: UIImage(systemName: "square.stack.3d.up"), tag: 0)
        navController.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navController.navigationBar.shadowImage = UIImage()
        navController.navigationBar.tintColor = .black
        navController.delegate = self
        navController.pushViewController(insuranceOverviewViewController, animated: true)
    }

    func showInsurnaceDetail(_ insurance: Insurance) {
        let insurancesDetailViewController = InsurancesDetailViewController(insurance: insurance)
        insurancesDetailViewController.coordinator = self
        navController.pushViewController(insurancesDetailViewController, animated: true)
    }

    func logout() {
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
