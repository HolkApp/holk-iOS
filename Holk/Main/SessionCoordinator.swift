//
//  SessionCoordinator.swift
//  Holk
//
//  Created by 张梦皓 on 2019-10-13.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

// TODO: Use SessionCoordinator instead of OnboardingCoordinator for the login, signup check
final class SessionCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    // MARK: - Public Properties
    var navController: UINavigationController
    var storeController: StoreController
    private var onboardingCoordinator: OnboardingCoordinator
    // MARK: - Init
    init(navController: UINavigationController) {
        self.navController = navController
        self.storeController = StoreController()
        onboardingCoordinator = OnboardingCoordinator(navController: navController, storeController: storeController)
    }
    
    func start() {
        let landingViewController = StoryboardScene.Onboarding.landingViewController.instantiate()
        landingViewController.coordinator = self
        navController.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navController.navigationBar.shadowImage = UIImage()
        navController.delegate = self
        navController.navigationBar.tintColor = .black
        navController.pushViewController(landingViewController, animated: true)
    }
    
    func showLogin(presentByRoot: Bool = false) {
        let vc = StoryboardScene.Onboarding.loginViewController.instantiate()
        vc.coordinator = self
        vc.storeController = storeController
        navController.pushViewController(vc, animated: true)
        if presentByRoot {
            popOtherViewControllers()
        }
    }
    
    func showSignup(presentByRoot: Bool = false) {
        let vc = StoryboardScene.Onboarding.signupViewController.instantiate()
        vc.coordinator = self
        vc.storeController = storeController
        navController.pushViewController(vc, animated: true)
        if presentByRoot {
            popOtherViewControllers()
        }
    }
    
    func onboarding() {
        onboardingCoordinator.start()
        onboardingCoordinator.delegate = self
    }
    
    func displayOnBoradingInfo() {
        let vc = StoryboardScene.Onboarding.onboardingInfoContainerViewController.instantiate()
        vc.coordinator = self
        navController.pushViewController(vc, animated: true)
    }
    
    // TODO: Pass the token or session
    func showSession() {
        let tabbarController = TabBarController()
        tabbarController.modalPresentationStyle = .overFullScreen
        if navController.presentedViewController != nil {
                navController.dismiss(animated: true) {
                    self.navController.present(tabbarController, animated: true) {
                        self.navController.popToRootViewController(animated: false)
                    }
                }
            } else {
            navController.present(tabbarController, animated: true) {
                self.navController.popToRootViewController(animated: false)
            }
        }
    }
}

extension SessionCoordinator: OnboardingCoordinatorDelegate {
    func didFinishOnboarding(coordinator: OnboardingCoordinator) {
        showSession()
    }
}
