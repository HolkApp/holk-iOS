//
//  OnboardingCoordinator.swift
//  Holk
//
//  Created by 张梦皓 on 2020-05-02.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

protocol OnboardingContainerCoordinating: AnyObject {
    func onboardingStopped(_ onboardingContainerViewController: OnboardingContainerViewController)
    func onboardingFinished(_ onboardingContainerViewController: OnboardingContainerViewController)
}

final class OnboardingCoordinator {
    var coordinator: ShellCoordinator?
    
    private var navigationController: UINavigationController
    private var storeController: StoreController
    private var onboardingContainerViewController: OnboardingContainerViewController
    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid

    init(navigationController: UINavigationController, storeController: StoreController) {
        self.navigationController = navigationController
        self.storeController = storeController
        onboardingContainerViewController = OnboardingContainerViewController(storeController: storeController)
    }

    func start() {
        onboardingContainerViewController.coordinator = self
        navigationController.pushViewController(onboardingContainerViewController, animated: false)

        onboardingContainerViewController.loading()

        authenticate()
    }
}

extension OnboardingCoordinator {
    private func authenticate() {
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
        if navigationController.presentingViewController != nil {
            navigationController.dismiss(animated: false) {
                self.navigationController.present(alert, animated: true)
            }
        } else {
            navigationController.present(alert, animated: true)
        }
    }

    private func showOnboardingFlow() {
        onboardingContainerViewController.startOnboarding(storeController.user)
       }
}


// MARK: - OnboardingCoordinator
extension OnboardingCoordinator: OnboardingContainerCoordinating {
    func onboardingStopped(_ onboardingContainerViewController: OnboardingContainerViewController) {
        coordinator?.onboardingStopped()
    }

    func onboardingFinished(_ onboardingContainerViewController: OnboardingContainerViewController) {
        coordinator?.onboardingFinished()
    }
}
