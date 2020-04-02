//
//  InsuranceCostDetailCoordinator.swift
//  Holk
//
//  Created by 张梦皓 on 2019-07-21.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit


class InsuranceCostDetailCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    var navController: UINavigationController
    
    // MARK: - Init
    init(navController: UINavigationController) {
        self.navController = navController
    }
    
    func start() {
        navController.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navController.navigationBar.shadowImage = UIImage()
        navController.delegate = self
    }
    
    func showDetail() {
        let insuranceCostDetailViewController = StoryboardScene.InsuranceOverview
            .insuranceCostDetailViewController.instantiate()
        insuranceCostDetailViewController.coordinator = self
        navController.pushViewController(insuranceCostDetailViewController, animated: true)
    }
    
    // MARK: - UINavigationControllerDelegate
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let insuranceOverviewViewController = fromVC as? InsuranceOverviewViewController,
            insuranceOverviewViewController.currentChildSegmentViewController is InsuranceCostViewController,
            toVC is InsuranceCostDetailViewController {
            return InsuranceCostDetailTransition()
        } else if fromVC is InsuranceCostDetailViewController, toVC is InsuranceOverviewViewController {
            // back navigation transition
        }
        return nil
    }
}
