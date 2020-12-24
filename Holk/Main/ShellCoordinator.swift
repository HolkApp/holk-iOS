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
    private var authenticationCoordinator: AuthenticationCoordinator?
    private var onboardingCoordinator: OnboardingCoordinator?
    private lazy var landingPageNavigationController: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.tintColor = Color.mainForeground
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
        setupViewController()
    }

    private func setupViewController() {
        switch storeController.sessionState {
        case .new:
            DispatchQueue.main.async {
                self.showLandingScreen()
            }
        case .expired:
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
            storeController.insuranceStore.allInsurances { [weak self] _ in
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

    func authenticate(authenticateOnOtherDevice: Bool = false) {
        authenticationCoordinator = AuthenticationCoordinator(navigationController: landingPageNavigationController, storeController: storeController)
        authenticationCoordinator?.delegate = self
        authenticationCoordinator?.start(authenticateOnOtherDevice)
    }

    func logout() {
        storeController.resetSession()
        storeController = StoreController()
        rootViewController.dismiss(animated: false) {
            DispatchQueue.main.async {
                self.setupViewController()
                self.authenticationCoordinator = nil
                self.sessionCoordinator = nil
            }
        }
    }

    private func showSession() {
        sessionCoordinator = SessionCoordinator(presenterViewController: rootViewController, storeController: storeController)
        sessionCoordinator?.coordinator = self
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

    private func showError(_ error: Error) {
        let alert = UIAlertController(
            title: LocalizedString.Generic.Error.title,
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(.init(
            title: LocalizedString.Generic.close,
            style: .default,
            handler: { action in
                alert.dismiss(animated: true)
            })
        )

        if landingPageNavigationController.presentedViewController != nil {
            landingPageNavigationController.dismiss(animated: false) {
                self.landingPageNavigationController.present(alert, animated: true)
            }
        } else {
            landingPageNavigationController.present(alert, animated: true)
        }
    }
}

extension ShellCoordinator: AuthenticationCoordinatorDelegate {
    func authenticationDidCancel(_ coordinator: AuthenticationCoordinator) {
        rootViewController.dismiss(animated: false) {
            self.showLandingScreen()
        }
    }

    func authentication(_ coordinator: AuthenticationCoordinator, didAuthenticateWith user: User) {
        storeController.suggestionStore.fetchAllSuggestions()
        storeController.insuranceStore.allInsurances { [weak self] result in
            guard let self = self else { return }
            if case .success(let insurances) = result, !insurances.isEmpty {
                self.rootViewController.dismiss(animated: false) {
                    self.showSession()
                }
            } else {
                self.onboardingCoordinator = OnboardingCoordinator(navigationController:
                    self.landingPageNavigationController, storeController: self.storeController, user: user)
                self.onboardingCoordinator?.delegate = self
                self.onboardingCoordinator?.start()
            }
        }
    }

    func authentication(_ coordinator: AuthenticationCoordinator, didFailWith error: Error) {
        showError(error)
    }
}

extension ShellCoordinator: OnboardingCoordinatorDelegate {
    func onboardingStopped(_ coordinator: OnboardingCoordinator) {
        self.logout()
    }

    func onboardingFinished(_ coordinator: OnboardingCoordinator) {
        rootViewController.dismiss(animated: false) {
            self.showSession()
            self.onboardingCoordinator = nil
        }
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
