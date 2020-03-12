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
    func addUserEmail(_ email: String)
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
        setupViewController()
    }
    
    func showSession() {
        let tabbarController = TabBarController(storeController: storeController)
        tabbarController.navigationItem.hidesBackButton = true
        tabbarController.coordinator = self
        tabbarController.modalPresentationStyle = .overFullScreen
        navController.setViewControllers([tabbarController], animated: false)
        if navController.presentedViewController != nil {
            navController.dismiss(animated: true)
        }
    }
    
    func startAuthentication() {
        showLoading()
        BankIDService.sign(redirectLink: "holk:///", successHandler: {
            NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { [weak self] _ in
                guard let self = self else { return }
                self.checkAuthenticationStatus()
            }
        }) { [weak self] in
            #if targetEnvironment(simulator)
            guard let self = self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.checkAuthenticationStatus()
            }
            #else
            // TODO: Should show some alert for downloading BankID on device
            #endif
        }
    }
    
    func checkAuthenticationStatus() {
        showAddNewUser()
        // TODO: Directly show insurance if not new user
    }
    
    func showAddNewUser() {
        let newUserViewController = NewUserViewController()
        newUserViewController.coordinator = self
        navController.pushViewController(newUserViewController, animated: false)
        navController.popMiddleViewControllers()
        navController.dismiss(animated: true)
    }
    
    func showLoading() {
        let loadingViewController = LoadingViewController()
        loadingViewController.modalPresentationStyle = .overFullScreen
        if navController.viewControllers.isEmpty {
            navController.setViewControllers([loadingViewController], animated: false)
        } else {
            navController.present(loadingViewController, animated: true) {
                // Pop out all the onboarding view controllers and leave the landing screen
                self.navController.popToRootViewController(animated: false)
            }
        }
    }
    
    func showInfoGuide() {
        let vc = StoryboardScene.Onboarding.onboardingInfoViewController.instantiate()
        vc.coordinator = self
        navController.pushViewController(vc, animated: true)
    }
    
    func logout() {
        storeController.resetSession()
        showLandingScreen()
    }
    
    private func setupViewController() {
        switch storeController.sessionState {
        case .newSession:
            showLandingScreen()
        case .shouldRefresh:
            showLoading()
            storeController.authenticationStore.refresh().subscribe().disposed(by: bag)
        case .updated:
            showLoading()
            DispatchQueue.main.async {
                self.showSession()
            }
        }
    }
    
    private func showLandingScreen() {
        let landingPageViewController = LandingPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        landingPageViewController.coordinator = self
        navController.setViewControllers([landingPageViewController], animated: false)
        navController.dismiss(animated: false)
    }

    private func showOnboardingFlow() {
        onboardingContainerViewController.startOnboarding()
        onboardingContainerViewController.modalPresentationStyle = .overFullScreen
        navController.present(onboardingContainerViewController, animated: false) {
            // Pop out all the onboarding view controllers and leave the landing screen
            self.navController.popToRootViewController(animated: false)
        }
    }

    private func newUserEmailAdded() {
        showOnboardingFlow()
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
    func addUserEmail(_ email: String) {
        storeController.insuranceIssuerStore.loadInsuranceIssuers()
        storeController.authenticationStore
            .login(username: email)
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
    }
    
    func finishOnboarding(coordinator: OnboardingContainerViewController) {
        showSession()
    }
}
