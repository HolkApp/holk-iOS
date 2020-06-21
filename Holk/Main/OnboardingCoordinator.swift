//
//  OnboardingCoordinator.swift
//  Holk
//
//  Created by 张梦皓 on 2020-05-02.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class OnboardingCoordinator {
    weak var coordinator: ShellCoordinator?
    
    private var navigationController: UINavigationController
    private var storeController: StoreController
    private var onboardingContainerViewController: OnboardingContainerViewController
    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    private var isPresentingQRCode = false

    init(navigationController: UINavigationController, storeController: StoreController) {
        self.navigationController = navigationController
        self.storeController = storeController
        onboardingContainerViewController = OnboardingContainerViewController(storeController: storeController)
    }

    func start(_ authenticateOnOtherDevice: Bool) {
        onboardingContainerViewController.delegate = self
        navigationController.pushViewController(onboardingContainerViewController, animated: false)

        onboardingContainerViewController.loading()
        authenticate(authenticateOnOtherDevice)
    }
}

extension OnboardingCoordinator {
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
        if handleOnOtherDevice {
            let deeplinkUrl = URL(string: "bankid:///?autostarttoken=\(bankIDAuthenticationResponse.autoStartToken)")
            authenticateWithQRCode(deeplinkUrl)
            checkAuthenticationStatus(orderRef: bankIDAuthenticationResponse.orderRef)
        } else {
            BankIDService.autostart(autoStart: bankIDAuthenticationResponse.autoStartToken, redirectLink: "holk://", successHandler: { [weak self] in
                guard let self = self else { return }
                self.backgroundTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
                    UIApplication.shared.endBackgroundTask(self.backgroundTask)
                })
                self.checkAuthenticationStatus(orderRef: bankIDAuthenticationResponse.orderRef)
            }) { [weak self] deepLinkUrl in
                self?.authenticateWithQRCode(deepLinkUrl)
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

        if navigationController.presentedViewController != nil {
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

    @objc private func dismissPresntedViewController(_ sender: Any) {
        self.navigationController.presentedViewController?.dismiss(animated: true)
    }
}


// MARK: - OnboardingCoordinator
extension OnboardingCoordinator: OnboardingContainerDelegate {
    func onboardingStopped(_ onboardingContainerViewController: OnboardingContainerViewController) {
        coordinator?.onboardingStopped()
    }

    func onboardingFinished(_ onboardingContainerViewController: OnboardingContainerViewController) {
        coordinator?.onboardingFinished()
    }
}
