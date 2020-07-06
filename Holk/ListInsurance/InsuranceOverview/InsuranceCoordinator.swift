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
        let layout = UICollectionViewCompositionalLayout.makeInsuranceListLayout()
        let insuranceListViewController = InsuranceListViewController(storeController: storeController, collectionViewLayout: layout)
        insuranceListViewController.coordinator = self

        navController.tabBarItem = UITabBarItem(title: "Översikt", image: UIImage(systemName: "square.stack.3d.up"), selectedImage: UIImage(systemName: "square.stack.3d.up.fill"))
        navController.navigationBar.tintColor = Color.mainForeground
        navController.navigationBar.prefersLargeTitles = true
        navController.delegate = self
        navController.setViewControllers([insuranceListViewController], animated: true)
    }

    func showInsurance(_ insurance: Insurance) {
        let insuranceViewController = InsuranceViewController(storeController: storeController, insurance: insurance)
        insuranceViewController.coordinator = self
        insuranceViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(back(_:)))
        navController.pushViewController(insuranceViewController, animated: true)
    }

    func showinsuranceDetail(_ insurance: Insurance) {
        let homeinsuranceSubmodelsViewController = HomeinsuranceSubmodelsViewController(storeController: storeController, insurance: insurance)
        homeinsuranceSubmodelsViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(back(_:)))
        navController.pushViewController(homeinsuranceSubmodelsViewController, animated: true)
    }

    func logout() {
        delegate?.logout(self)
    }

    @objc private func back(_ sender: Any) {
        navController.popViewController(animated: true)
    }
    
    // MARK: - UINavigationControllerDelegate
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if fromVC is InsuranceListViewController, toVC is InsuranceViewController {
            return InsuranceTransition()
        } else if fromVC is InsuranceViewController, toVC is InsuranceListViewController {
            return InsuranceTransition()
        } else if fromVC is InsuranceViewController, toVC is InsuranceDetailViewController {
            return InsuranceDetailTransition()
        } else if fromVC is InsuranceDetailViewController, toVC is InsuranceViewController {
            return InsuranceDetailTransition()
        }
        return nil
    }
}
