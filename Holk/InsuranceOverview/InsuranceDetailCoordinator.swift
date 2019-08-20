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
            let fromInsuranceCostViewController = insuranceOverviewViewController.currentChildSegmentViewController as? InsuranceCostViewController,
            let toInsuranceDetailViewController = toVC as? InsuranceDetailViewController {
            if let selectedIndexPath = fromInsuranceCostViewController.tableView.indexPathForSelectedRow {
                return InsuranceDetailTransition()
            }
        }
        return nil
    }
}

extension InsuranceDetailCoordinator: InsuranceDetailViewControllerDelegate {
    func controllerDismissed(insuranceDetailViewController: InsuranceDetailViewController) {
        if navController.topViewController == insuranceDetailViewController {
            navController.popViewController(animated: true)
        }
    }
}
