//
//  SessionCoordinator.swift
//  Holk
//
//  Created by 张梦皓 on 2019-10-13.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit
import RxSwift
import Combine

protocol OnboardingContainerCoordinating: AnyObject {
    func onboardingFinished(coordinator: OnboardingContainerViewController)
}

final class SessionCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    // MARK: - Public Properties
    var navController: UINavigationController
    var storeController: StoreController
    var cancellables = Set<AnyCancellable>()
    
    private let bag = DisposeBag()
    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    // MARK: - Init
    init(navController: UINavigationController) {
        self.navController = navController
        self.storeController = StoreController()
        
        super.init()

        storeController.delegate = self
    }
    
    func start() {
        navController.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navController.navigationBar.shadowImage = UIImage()
        navController.delegate = self
        navController.navigationBar.tintColor = Color.mainForegroundColor
        setupViewController()
    }
    
    func authenticate() {
        showLoading()
        storeController.authenticationStore.authenticate { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let bankIDAuthenticationResponse):
                self.handleAuthenticationUpdate(bankIDAuthenticationResponse)
            case .failure(let error):
                self.showError(error, requestName: "authorize/bank-id/auth")
            }
        }
    }

    func information() {
        let onboardingInfoViewController = OnboardingInfoViewController()
        onboardingInfoViewController.coordinator = self
        navController.pushViewController(onboardingInfoViewController, animated: true)
    }

    func logout() {
        storeController.resetSession()
        showLandingScreen()
    }

    private func handleAuthenticationUpdate(_ bankIDAuthenticationResponse: BankIDAuthenticationResponse) {
        BankIDService.autostart(autoStart: bankIDAuthenticationResponse.autoStartToken, redirectLink: "holk://", successHandler: { [weak self] in
            guard let self = self else { return }
            self.backgroundTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
                UIApplication.shared.endBackgroundTask(self.backgroundTask)
            })
            self.checkAuthenticationStatus(orderRef: bankIDAuthenticationResponse.orderRef)
        }) {
            #if targetEnvironment(simulator)
            #else
            #endif
            // TODO: Should show some alert for downloading BankID on device
        }
    }

    private func checkAuthenticationStatus(orderRef: String) {
        storeController.authenticationStore.token(orderRef: orderRef) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.storeController.insuranceProviderStore.fetchInsuranceProviders { _ in }
//                self.storeController.insuranceProviderStore.loadInsuranceIssuers()
                self.fetchUserInfo()
            case .failure(let error):
                self.showError(error, requestName: "authorize/oauth/token")
            }
        }
    }

    func fetchUserInfo() {
        storeController.userStore.userInfo { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.backgroundTask = .invalid
                switch result {
                case .success:
                    self.showOnboardingFlow()
                case .failure(let error):
                    self.showOnboardingFlow()
                    // TODO: Error handling
                    self.showError(error, requestName: "authorize/user")
                }
            }
            UIApplication.shared.endBackgroundTask(self.backgroundTask)
        }
    }

    private func showError(_ error: APIError, requestName: String) {
        let alert = UIAlertController(title: requestName + " \(error.code)", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(.init(
            title: "Close",
            style: .default,
            handler: { action in
                alert.dismiss(animated: true)
            })
        )
        navController.present(alert, animated: true)
    }
    
    private func setupViewController() {
        switch storeController.sessionState {
        case .newSession:
            showLandingScreen()
        case .shouldRefresh:
            showLoading()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.storeController.authenticationStore.refresh { _ in }
            }
        case .updated:
            showLoading()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showSession()
            }
        }
    }

    private func showLoading() {
        let loadingViewController = LoadingViewController()
        loadingViewController.modalPresentationStyle = .overFullScreen
        navController.setViewControllers([loadingViewController], animated: false)
    }
    
    private func showLandingScreen() {
        let landingPageViewController = LandingPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        landingPageViewController.coordinator = self
        navController.setViewControllers([landingPageViewController], animated: false)
    }

    private func showOnboardingFlow() {
        let onboardingContainerViewController = OnboardingContainerViewController(storeController: storeController)
        onboardingContainerViewController.coordinator = self
        onboardingContainerViewController.startOnboarding(storeController.user)
        onboardingContainerViewController.modalPresentationStyle = .overFullScreen
        navController.present(onboardingContainerViewController, animated: false) {
            // Pop out all the onboarding view controllers and leave the landing screen
            self.navController.popToRootViewController(animated: false)
            self.showLandingScreen()
        }
    }

    private func showSession() {
        let tabbarController = TabBarController(storeController: storeController)
        tabbarController.navigationItem.hidesBackButton = true
        tabbarController.coordinator = self
        navController.setViewControllers([tabbarController], animated: false)
        if navController.presentedViewController != nil {
            navController.dismiss(animated: true)
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
    func onboardingFinished(coordinator: OnboardingContainerViewController) {
        showSession()
    }
}
