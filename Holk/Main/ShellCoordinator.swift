//
//  ShellCoordinator.swift
//  Holk
//
//  Created by 张梦皓 on 2020-04-30.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit
import Combine

final class ShellCoordinator {
    var rootViewController: UIViewController

    private var storeController: StoreController
    private var cancellables = Set<AnyCancellable>()
    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    private var sessionCoordinator: SessionCoordinator?
    private var onboardingCoordinator: OnboardingCoordinator?
    private lazy var landingPageNavigationController: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.tintColor = Color.mainForegroundColor
        navigationController.modalPresentationStyle = .overFullScreen
        return navigationController
    }()

    // MARK: - Init
    init() {
        let loadingViewController = LoadingViewController()
        loadingViewController.modalPresentationStyle = .overFullScreen
        rootViewController = loadingViewController
        self.storeController = StoreController()
        storeController.delegate = self
    }

    func start() {
        sessionCoordinator = SessionCoordinator(presenterViewController: rootViewController, storeController: storeController)
        sessionCoordinator?.coordinator = self
        onboardingCoordinator = OnboardingCoordinator(navigationController: landingPageNavigationController, storeController: storeController)
        onboardingCoordinator?.coordinator = self
        setupViewController()
    }

    private func setupViewController() {
        switch storeController.sessionState {
        case .newSession:
            DispatchQueue.main.async {
                self.showLandingScreen()
            }
        case .shouldRefresh:
            showLoading()
            self.storeController.authenticationStore.refresh { [weak self] result in
                switch result {
                case .failure:
                    self?.storeController.user.reset()
                case .success:
                    break
                }
                self?.setupViewController()
            }
        case .updated:
            showLoading()
            storeController.userStore.userInfo()
            storeController.providerStore.fetchInsuranceProviders()
            storeController.suggestionStore.fetchAllSuggestions()
            storeController.insuranceStore.fetchAllInsurances { [weak self] _ in
                self?.showSession()
            }
        }
    }

    private func showLoading() {
        UIView.performWithoutAnimation {
            if rootViewController.presentingViewController != nil {
                rootViewController.dismiss(animated: true)
            }
        }
    }

    private func showLandingScreen() {
        let landingPageViewController = LandingPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        landingPageViewController.coordinator = self
        landingPageNavigationController.setViewControllers([landingPageViewController], animated: false)
        rootViewController.present(landingPageNavigationController, animated: false)
    }

    func authenticate() {
        onboardingCoordinator?.start()
    }

    func onboardingStopped() {
        rootViewController.dismiss(animated: false) {
            self.showLandingScreen()
        }
    }

    func onboardingFinished() {
        rootViewController.dismiss(animated: false) {
            self.showSession()
        }
    }

    func logout() {
        storeController.resetSession()
        rootViewController.dismiss(animated: false) {
            DispatchQueue.main.async {
                self.setupViewController()
            }
        }
    }

    private func showSession() {
        sessionCoordinator?.start()
    }
}

// Show Information
extension ShellCoordinator {
    func information() {
        let onboardingInfoViewController = OnboardingInfoViewController()
        onboardingInfoViewController.coordinator = self
        landingPageNavigationController.pushViewController(onboardingInfoViewController, animated: true)
    }
}

extension ShellCoordinator: StoreControllerDelegate {
    func storeControllerAccessTokenUpdated() {
        showSession()
    }

    func storeControllerRefreshTokenExpired() {
        logout()
    }
}
