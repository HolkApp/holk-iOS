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

final class InsuranceCoordinator: NSObject, UINavigationControllerDelegate {
    // MARK: - Public Variables
    var storeController: StoreController
    weak var delegate: InsuranceCoordinatorDelegate?
    let navController = UINavigationController()

    // MARK: - Init
    init(storeController: StoreController) {
        self.storeController = storeController
    }
    // MARK: - Public Methods
    func start() {
        let layout = UICollectionViewCompositionalLayout.makeInsuranceListLayout()
        let insuranceListViewController = InsuranceListViewController(storeController: storeController, collectionViewLayout: layout)
        insuranceListViewController.coordinator = self

        navController.navigationBar.prefersLargeTitles = true
        navController.tabBarItem = UITabBarItem(title: "Översikt", image: UIImage(systemName: "square.stack.3d.up"), selectedImage: UIImage(systemName: "square.stack.3d.up.fill"))
        navController.delegate = self
        navController.pushViewController(insuranceListViewController, animated: false)
    }

    func showInsurance(_ insurance: Insurance) {
        let homeInsuranceViewController = HomeInsuranceViewController(storeController: storeController, insurance: insurance)
        homeInsuranceViewController.coordinator = self
        navController.pushViewController(homeInsuranceViewController, animated: true)
    }

    func showinsuranceDetail(_ insurance: Insurance) {
        let homeinsuranceSubInsurancesViewController = HomeSubInsurancesViewController(storeController: storeController, insurance: insurance)
        navController.pushViewController(homeinsuranceSubInsurancesViewController, animated: true)
    }

    func logout() {
        delegate?.logout(self)
    }

    @objc private func back(_ sender: Any) {
        navController.popViewController(animated: true)
    }
    
    // MARK: - UINavigationControllerDelegate
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if fromVC is InsuranceListViewController, toVC is HomeInsuranceViewController {
            return InsuranceTransition()
        } else if fromVC is HomeInsuranceViewController, toVC is InsuranceListViewController {
            return InsuranceTransition()
        }
        return nil
    }
}
