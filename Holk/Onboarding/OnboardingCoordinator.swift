//
//  LoginCoordinator.swift
//  Holk
//
//  Created by 张梦皓 on 2019-04-30.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

protocol BackNavigation: AnyObject {
    func back()
}

final class OnboardingCoordinator: NSObject, Coordinator, BackNavigation, UINavigationControllerDelegate {
    // MARK: - Public Properties
    var navController: UINavigationController
    var storeController: StoreController
    // MARK: - Init
    init(navController: UINavigationController) {
        self.navController = navController
        storeController = StoreController()
    }
    
    // MARK: - Public Methods
    func start() {
        let vc = StoryboardScene.Onboarding.onboardingLandingViewController.instantiate()
        vc.coordinator = self
        navController.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navController.navigationBar.shadowImage = UIImage()
        navController.delegate = self
        navController.navigationBar.tintColor = .black
        navController.pushViewController(vc, animated: true)
    }
    
    func login(presentByRoot: Bool = false) {
        let vc = StoryboardScene.Onboarding.onboardingLoginViewController.instantiate()
        vc.coordinator = self
        vc.storeController = storeController
        navController.pushViewController(vc, animated: true)
        if presentByRoot {
            popOtherViewControllers()
        }
    }
    
    func signup(presentByRoot: Bool = false) {
        let vc = StoryboardScene.Onboarding.onboardingSignupViewController.instantiate()
        vc.coordinator = self
        vc.storeController = storeController
        navController.pushViewController(vc, animated: true)
        if presentByRoot {
            popOtherViewControllers()
        }
    }
    
    func onboarding() {
        let vc = StoryboardScene.Onboarding.insuranceProviderTypeViewController.instantiate()
        vc.coordinator = self
        navController.pushViewController(vc, animated: true)
    }
    
    // MARK: - OnBoardingInfo
    func displayOnBoradingInfo() {
        let vc = StoryboardScene.Onboarding.onboardingInfoContainerViewController.instantiate()
        vc.coordinator = self
        navController.pushViewController(vc, animated: true)
    }
    
    
    // MARK: - BackNavigation
    func back() {
        // In case the navbar is hidden and handle the back nav programmaticlly
        navController.popViewController(animated: true)
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
