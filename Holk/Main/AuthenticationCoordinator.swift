//
//  AuthenticationCoordinator.swift
//  Holk
//
//  Created by 张梦皓 on 2020-05-02.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

protocol AuthenticationCoordinatorDelegate: AnyObject {
    func onboardingStopped(_ coordinator: AuthenticationCoordinator)
    func onboardingFinished(_ coordinator: AuthenticationCoordinator)
}

final class AuthenticationCoordinator {
    weak var coordinator: AuthenticationCoordinatorDelegate?
    
    private var navigationController: UINavigationController
    private var storeController: StoreController

    private weak var onboardingContainerViewController: OnboardingContainerViewController?

    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    private var isPresentingQRCode = false

    init(navigationController: UINavigationController, storeController: StoreController) {
        self.navigationController = navigationController
        self.storeController = storeController
    }

    func start(_ authenticateOnOtherDevice: Bool) {
        let onboardingContainerViewController = OnboardingContainerViewController(storeController: storeController)
        onboardingContainerViewController.delegate = self
        navigationController.pushViewController(onboardingContainerViewController, animated: false)
        self.onboardingContainerViewController = onboardingContainerViewController

        onboardingContainerViewController.loading()
        authenticate(authenticateOnOtherDevice)
    }
}

extension AuthenticationCoordinator {
    private func authenticate(_ authenticateOnOtherDevice: Bool) {
        storeController.authenticationStore.authenticate { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let bankIDAuthenticationResponse):
                self.handleAuthenticationUpdate(bankIDAuthenticationResponse, handleOnOtherDevice: authenticateOnOtherDevice)
            case .failure(let error):
                self.showError(error, requestName: "authorize/bank-id/auth")
            }
        }
    }

    private func handleAuthenticationUpdate(_ bankIDAuthenticationResponse: BankIDAuthenticationResponse, handleOnOtherDevice: Bool) {
        guard let deeplinkUrl = BankIDService.makeDeeplink(autoStart: bankIDAuthenticationResponse.autoStartToken) else {
            return
        }
        if handleOnOtherDevice {
            authenticateWithQRCode(deeplinkUrl)
            checkAuthenticationStatus(orderRef: bankIDAuthenticationResponse.orderRef)
        } else {
            BankIDService.start(deeplinkUrl, { [weak self] in
                guard let self = self else { return }
                self.backgroundTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
                    UIApplication.shared.endBackgroundTask(self.backgroundTask)
                })
                self.checkAuthenticationStatus(orderRef: bankIDAuthenticationResponse.orderRef)
            }) { [weak self] deeplinkUrl in
                self?.authenticateWithQRCode(deeplinkUrl)
                self?.checkAuthenticationStatus(orderRef: bankIDAuthenticationResponse.orderRef)
            }
        }
    }

    private func authenticateWithQRCode(_ deepLinkUrl: URL?) {
        guard let deepLinkUrl = deepLinkUrl, let qrImage = BankIDService.generateQRCode(from: deepLinkUrl.absoluteString) else { return }
        DispatchQueue.main.async {
            let qrCodeViewController = HolkQRCodeViewController(qrImage: qrImage)
            qrCodeViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(self.dismissPresntedViewController(_:)))
            let qrController = UINavigationController(rootViewController: qrCodeViewController)
            self.navigationController.present(qrController, animated: true) { [weak self] in
                self?.isPresentingQRCode = true
            }
        }
    }

    private func checkAuthenticationStatus(orderRef: String) {
        storeController.authenticationStore.token(orderRef: orderRef) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.storeController.providerStore.fetchInsuranceProviders()
                self.fetchUserInfo()
                if self.isPresentingQRCode {
                    self.isPresentingQRCode = false
                    self.navigationController.dismiss(animated: true)
                }
            case .failure(let error):
                self.showError(error, requestName: "authorize/oauth/token")
            }
        }
    }

    func fetchUserInfo() {
        storeController.userStore.userInfo { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                UIApplication.shared.endBackgroundTask(self.backgroundTask)
                self.backgroundTask = .invalid
                switch result {
                case .success(let user):

                    self.showOnboardingFlow()
                case .failure(let error):
                    self.showOnboardingFlow()
                    // TODO: Error handling
                    self.showError(error, requestName: "authorize/user")
                }
            }
        }
    }

    private func showError(_ error: APIError, requestName: String) {
        let alert = UIAlertController(title: requestName + (String(describing: error.errorCode)), message: error.debugMessage, preferredStyle: .alert)
        alert.addAction(.init(
            title: "Close",
            style: .default,
            handler: { action in
                alert.dismiss(animated: true)
            })
        )

        if navigationController.presentedViewController != nil {
            navigationController.dismiss(animated: false) {
                self.navigationController.present(alert, animated: true)
            }
        } else {
            navigationController.present(alert, animated: true)
        }
    }

    private func showOnboardingFlow() {
        onboardingContainerViewController?.startOnboarding(storeController.user)
    }

    @objc private func dismissPresntedViewController(_ sender: Any) {
        self.navigationController.presentedViewController?.dismiss(animated: true)
    }
}


// MARK: - AuthenticationCoordinator
extension AuthenticationCoordinator: OnboardingContainerDelegate {
    func onboardingStopped(_ onboardingContainerViewController: OnboardingContainerViewController) {
        coordinator?.onboardingStopped(self)
        storeController.authenticationStore.cancelAll()
    }

    func onboardingFinished(_ onboardingContainerViewController: OnboardingContainerViewController) {
        coordinator?.onboardingFinished(self)
    }
}
