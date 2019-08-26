//
//  InsuranceDetailCoordinator.swift
//  Holk
//
//  Created by 张梦皓 on 2019-07-21.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit


class InsuranceDetailCoordinator: NSObject, Coordinator, BackNavigation, UINavigationControllerDelegate {
    
    lazy var insuranceDetailViewController: InsuranceDetailViewController = {
        let vc = StoryboardScene.InsuranceOverview
            .insuranceDetailViewController.instantiate()
        vc.coordinator = self
        return vc
    }()
    
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
        navController.pushViewController(insuranceDetailViewController, animated: true)
    }
    
    // MARK: - BackNavigation
    func back() {
        navController.popViewController(animated: true)
    }
    
    // MARK: - UINavigationControllerDelegate
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let insuranceOverviewViewController = fromVC as? InsuranceOverviewViewController,
            insuranceOverviewViewController.currentChildSegmentViewController is InsuranceCostViewController,
            toVC is InsuranceDetailViewController {
            return InsuranceDetailTransition()
        } else if fromVC is InsuranceDetailViewController, toVC is InsuranceOverviewViewController {
            // back navigation transition
        }
        return nil
    }
}
