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
    func onboardingFinished(coordinator: OnboardingContainerViewController)
}

final class SessionCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    // MARK: - Public Properties
    var navController: UINavigationController
    var storeController: StoreController
    
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
        navController.navigationBar.tintColor = .black
        setupViewController()
    }
    
    func authenticate() {
        showLoading()
        storeController.authenticationStore.authenticate()
            .observeOn(MainScheduler.instance)
            .catchErrorJustReturn(.failure(APIError.network))
            .map({ [weak self] result in
                self?.handleAuthenticationUpdate(result)
            })
            .subscribe()
            .disposed(by: bag)
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

    private func handleAuthenticationUpdate(_ result: Result<BankIDAuthenticationResponse, APIError>) {
        switch result {
        case .success(let authenticationResponse):
            BankIDService.autostart(autoStart: authenticationResponse.autoStartToken, redirectLink: "holk://", successHandler: { [weak self] in
                guard let self = self else { return }
                self.backgroundTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
                    UIApplication.shared.endBackgroundTask(self.backgroundTask)
                })
                self.checkAuthenticationStatus(orderRef: authenticationResponse.orderRef)
            }) {
                #if targetEnvironment(simulator)
                #else
                #endif
                // TODO: Should show some alert for downloading BankID on device
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
            .map({ [weak self] result in
                guard let self = self else { return }
                UIApplication.shared.endBackgroundTask(self.backgroundTask)
                self.backgroundTask = .invalid

                switch result {
                case .success:
                    self.showOnboardingFlow()
                case .failure(let error):
                    // TODO: Error handling
                    print(error)
                }
            })
            .flatMap(weak: self, selector: { (obj, result) -> Observable<Result<Void, APIError>> in
                obj.storeController.insuranceIssuerStore.loadInsuranceIssuers()
                return obj.storeController.authenticationStore.userInfo()
            })
            .subscribe()
            .disposed(by: bag)
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
        tabbarController.modalPresentationStyle = .overFullScreen
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
