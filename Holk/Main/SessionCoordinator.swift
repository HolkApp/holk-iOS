//
//  SessionCoordinator.swift
//  Holk
//
//  Created by 张梦皓 on 2019-10-13.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit
import RxSwift

// TODO: Use SessionCoordinator instead of OnboardingCoordinator for the login, signup check
final class SessionCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    // MARK: - Public Properties
    var navController: UINavigationController
    var storeController: StoreController
    
    private var onboardingCoordinator: OnboardingCoordinator
    private let bag = DisposeBag()
    
    // MARK: - Init
    init(navController: UINavigationController) {
        self.navController = navController
        self.storeController = StoreController()
        onboardingCoordinator = OnboardingCoordinator(navController: navController, storeController: storeController)
        super.init()
        
        storeController.delegate = self
    }
    
    func start() {
        navController.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navController.navigationBar.shadowImage = UIImage()
        navController.delegate = self
        navController.navigationBar.tintColor = .black
        switch storeController.sessionState {
        case .newSession:
            showLandingScreen()
        case .shouldRefresh:
            showLoading()
            storeController.authenticationStore.refresh().subscribe().disposed(by: bag)
        case .updated:
            showSession()
        }
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
    
    func showLandingScreen() {
        let landingViewController = StoryboardScene.Onboarding.landingViewController.instantiate()
        landingViewController.coordinator = self
        if navController.presentedViewController != nil {
            if !(self.navController.topViewController is LandingViewController) {
                self.navController.setViewControllers([landingViewController], animated: true)
            }
            navController.dismiss(animated: true)
        } else {
            navController.pushViewController(landingViewController, animated: false)
        }
    }
    
    func showSession(presentByRoot: Bool = false) {
        let tabbarController = TabBarController()
        tabbarController.coordinator = self
        tabbarController.modalPresentationStyle = .overFullScreen
        if navController.viewControllers.isEmpty {
            navController.pushViewController(tabbarController, animated: true)
        } else if navController.presentedViewController != nil {
            navController.dismiss(animated: true) {
                self.navController.present(tabbarController, animated: true) {
                    self.navController.popToRootViewController(animated: false)
                }
            }
        } else {
            navController.present(tabbarController, animated: true) {
                // Pop out all the onboarding view controllers and leave the landing screen
                self.navController.popToRootViewController(animated: false)
            }
        }
    }
    
    func showLoading() {
        let loadingViewController = LoadingViewController()
        loadingViewController.modalPresentationStyle = .overFullScreen
        if navController.viewControllers.isEmpty {
            navController.pushViewController(loadingViewController, animated: true)
        } else if navController.presentedViewController != nil {
            navController.dismiss(animated: true) {
                self.navController.present(loadingViewController, animated: true) {
                    self.navController.popToRootViewController(animated: false)
                }
            }
        } else {
            navController.present(loadingViewController, animated: true) {
                // Pop out all the onboarding view controllers and leave the landing screen
                self.navController.popToRootViewController(animated: false)
            }
        }
    }
    
    func logout() {
        storeController.resetSession()
        start()
    }
}

extension SessionCoordinator: StoreControllerDelegate {
    func storeControllerAccessTokenUpdated() {
        showSession()
    }
    
    func storeControllerRefreshTokenExpired() {
        logout()
    }
}

extension SessionCoordinator: OnboardingCoordinatorDelegate {
    func didFinishOnboarding(coordinator: OnboardingCoordinator) {
        showSession()
    }
}
