//
//  LoginCoordinator.swift
//  Holk
//
//  Created by 张梦皓 on 2019-04-30.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

protocol OnBoardingInfo: AnyObject {
    func displayOnBoradingInfo()
}

protocol BackNavigation: AnyObject {
    func back()
}

final class LoginCoordinator: NSObject, Coordinator, OnBoardingInfo, BackNavigation, UINavigationControllerDelegate {
    // MARK: - Public Properties
    var navController: UINavigationController
    
    // MARK: - Init
    init(navController: UINavigationController) {
        self.navController = navController
    }
    
    // MARK: - Public Methods
    func start() {
        let vc = StoryboardScene.Main.loginViewController.instantiate()
        vc.coordinator = self
        navController.isNavigationBarHidden = true
        navController.delegate = self
        navController.pushViewController(vc, animated: true)
    }
    
    // MARK: - BackNavigation
    func back() {
        // In case the navbar is hidden and handle the back nav programmaticlly
        navController.popViewController(animated: true)
    }
    
    // MARK: - OnBoardingInfo
    func displayOnBoradingInfo() {
        let vc = StoryboardScene.Main.onboardingInfoViewController.instantiate()
        vc.coordinator = self
        navController.pushViewController(vc, animated: true)
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
