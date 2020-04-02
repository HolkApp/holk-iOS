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
        let insuranceDetailViewController = InsuranceDetailViewController(insurance: insurance)
        insuranceDetailViewController.coordinator = self
        navController.pushViewController(insuranceDetailViewController, animated: true)
    }

    func logout() {
        delegate?.logout(self)
    }
    
    // MARK: - UINavigationControllerDelegate
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let insuranceOverviewViewController = fromVC as? InsuranceOverviewViewController,
            insuranceOverviewViewController.currentChildSegmentViewController is InsurancesViewController,
            toVC is InsuranceDetailViewController {
            return InsuranceDetailTransition()
        } else if fromVC is InsuranceDetailViewController, toVC is InsuranceOverviewViewController {
            // back navigation transition
        }
        return nil
    }
}
