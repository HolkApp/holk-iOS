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
        showOnboardingFlow()
        storeController.authenticationStore.authenticate()
            .observeOn(MainScheduler.instance)
            .catchErrorJustReturn(.failure(APIError.network))
            .map({ [weak self] result in
                self?.handleAuthenticationUpdate(result)
            })
            .subscribe()
            .disposed(by: bag)
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

    private func handleAuthenticationUpdate(_ result: Result<BankIDAuthenticationResponse, APIError>) {
        switch result {
        case .success(let authenticationResponse):
            checkAuthenticationStatus(orderRef: authenticationResponse.orderRef)

            BankIDService.autostart(autoStart: authenticationResponse.autoStartToken, redirectLink: "holk://", successHandler: {
                // nothing
            }) {
                #if targetEnvironment(simulator)
                // TODO: Should show some alert for downloading BankID on device
                #else
                // TODO: Should show some alert for downloading BankID on device
                #endif
            }
        case .failure(let error):
            // TODO: Error handling
            print(error)
        }
    }
    
    private func checkAuthenticationStatus(orderRef: String) {
        storeController
            .authenticationStore
            .token(orderRef: orderRef)
            .badNetworkRetrier()
            .map({ [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success:
                    if self.storeController.newUser {
                        self.showAddNewUser()
                    } else {
                        self.onboardingContainerViewController.loadingFinished()
                    }
                    self.storeController.insuranceIssuerStore.loadInsuranceIssuers()
                case .failure(let error):
                    // TODO: Error handling
                    print(error)
                }
            })
            .subscribe()
            .disposed(by: bag)
    }
    
    private func showAddNewUser() {
        let newUserViewController = NewUserViewController()
        newUserViewController.coordinator = self
        navController.pushViewController(newUserViewController, animated: false)
        navController.popMiddleViewControllers()
        navController.dismiss(animated: true)
    }
    
    private func showLoading() {
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
        showOnboardingFlow()
        storeController.insuranceIssuerStore.loadInsuranceIssuers()
        // TODO: call to register the email with real endpoint and when success to the following
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.onboardingContainerViewController.loadingFinished()
        }

    }
    
    func finishOnboarding(coordinator: OnboardingContainerViewController) {
        showSession()
    }
}
