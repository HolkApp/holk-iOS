//
//  SessionCoordinator.swift
//  Holk
//
//  Created by 张梦皓 on 2019-10-13.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit
import RxSwift

protocol OnboardingContainerCoordinating: AnyObject {
    func startOnboarding(_ username: String)
    func finishOnboarding(coordinator: OnboardingContainerViewController)
}

final class SessionCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    // MARK: - Public Properties
    var navController: UINavigationController
    var storeController: StoreController
    
    private var onboardingContainerViewController: OnboardingContainerViewController
    private let bag = DisposeBag()
    
    // MARK: - Init
    init(navController: UINavigationController) {
        self.navController = navController
        self.storeController = StoreController()
        self.onboardingContainerViewController = OnboardingContainerViewController(storeController: storeController)
        
        super.init()
        
        onboardingContainerViewController.coordinator = self
        storeController.delegate = self
    }
    
    func start() {
        navController.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navController.navigationBar.shadowImage = UIImage()
        navController.delegate = self
        navController.navigationBar.tintColor = .black
        showInitialScreen()
    }
    
    func showSession(initialScreen: Bool = false) {
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
    
    func startAuthentication() {
        BankIDService.sign(redirectLink: "holk:///", successHandler: {
            NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { [weak self] _ in
                guard let self = self else { return }
                self.checkAuthenticationStatus()
            }
        }) { [weak self] in
            #if targetEnvironment(simulator)
            // TODO: Should show some alert for downloading BankID
            guard let self = self else { return }
            self.checkAuthenticationStatus()
            #else
            
            #endif
        }
    }
    
    func checkAuthenticationStatus() {
        showLoading()
        // TODO: Update this when have real endpoint
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.showNewUser(shouldPopOtherViews: true)
        }
        // TODO: Directly show insurance if not new user
    }
    
    func showNewUser(shouldPopOtherViews: Bool = false) {
        let vc = StoryboardScene.Onboarding.newUserViewController.instantiate()
        vc.coordinator = self

        navController.pushViewController(vc, animated: true)
        // TODO: Refactor the navigation for loading since we have new flow
        navController.dismiss(animated: true)
        if shouldPopOtherViews {
            popOtherViewControllers()
        }
    }
    
    func onboarding() {
        onboardingContainerViewController.modalPresentationStyle = .overFullScreen
        if navController.viewControllers.isEmpty {
            navController.pushViewController(onboardingContainerViewController, animated: true)
        } else if navController.presentedViewController != nil {
            navController.dismiss(animated: true) { [weak self] in
                guard let self = self else { return }
                self.navController.present(self.onboardingContainerViewController, animated: true) {
                    self.navController.popToRootViewController(animated: false)
                }
            }
        } else {
            navController.present(onboardingContainerViewController, animated: false) {
                // Pop out all the onboarding view controllers and leave the landing screen
                self.navController.popToRootViewController(animated: false)
            }
        }
    }
    
    func showLoading(initialScreen: Bool = false) {
        let loadingViewController = LoadingViewController()
        loadingViewController.modalPresentationStyle = .overFullScreen
        if initialScreen || navController.presentedViewController != nil {
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
    
    func displayInfo() {
        let vc = StoryboardScene.Onboarding.onboardingInfoViewController.instantiate()
        vc.coordinator = self
        navController.pushViewController(vc, animated: true)
    }
    
    func logout() {
        storeController.resetSession()
        start()
    }
    
    private func showInitialScreen() {
        switch storeController.sessionState {
        case .newSession:
            showLandingScreen(initialScreen: true)
        case .shouldRefresh:
            showLoading(initialScreen: true)
            storeController.authenticationStore.refresh().subscribe().disposed(by: bag)
        case .updated:
            showSession(initialScreen: true)
        }
    }
    
    private func showLandingScreen(initialScreen: Bool = false) {
        let landingPageViewController = LandingPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        landingPageViewController.coordinator = self
        if !(self.navController.topViewController is LandingPageViewController) {
            self.navController.setViewControllers([landingPageViewController], animated: true)
        }
        navController.dismiss(animated: true)
    }
    
    private func newUserEmailAdded() {
        onboardingContainerViewController.loadingFinished()
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

// MARK: - SessionCoordinating
extension SessionCoordinator: OnboardingContainerCoordinating {
    func startOnboarding(_ username: String) {
        storeController.authenticationStore
            .login(username: username)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] event in
                switch event {
                case .success:
                    self?.newUserEmailAdded()
                case .failure(let error):
                    // TODO: Error handling
                    print(error)
                    self?.newUserEmailAdded()
                }
                }, onError: { [weak self] error in
                    // TODO: Error handling
                    print(error)
                    self?.newUserEmailAdded()
            }).disposed(by: bag)
        
        onboarding()
    }
    
    func finishOnboarding(coordinator: OnboardingContainerViewController) {
        showSession()
    }
}
