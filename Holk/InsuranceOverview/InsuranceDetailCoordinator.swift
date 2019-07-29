//
//  InsuranceDetailCoordinator.swift
//  Holk
//
//  Created by 张梦皓 on 2019-07-21.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit


class InsuranceDetailCoordinator: NSObject, Coordinator, BackNavigation, UINavigationControllerDelegate {
    
    var navController: UINavigationController
    
    // MARK: - Init
    init(navController: UINavigationController) {
        self.navController = navController
    }
    
    func start() {
        navController.isNavigationBarHidden = true
        navController.delegate = self
    }
    
    func showDetail() {
        let vc = StoryboardScene.InsuranceOverview.insuranceDetailViewController.instantiate()
        vc.coordinator = self
        navController.pushViewController(vc, animated: true)
    }
    
    // MARK: - BackNavigation
    func back() {
        navController.popViewController(animated: true)
    }
    
    // MARK: - UINavigationControllerDelegate
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from),
            let toViewController = navigationController.transitionCoordinator?.viewController(forKey: .to) else {
            return
        }
        
        if let insuranceOverviewViewController = fromViewController as? InsuranceOverviewViewController,
            let insuranceDetailViewController = toViewController as? InsuranceDetailViewController,
            let InsuranceCostViewController = insuranceOverviewViewController.currentChildSegmentViewController as? InsuranceCostViewController {

        }
    }
}
