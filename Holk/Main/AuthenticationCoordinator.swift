//
//  AuthenticationCoordinator.swift
//  Holk
//
//  Created by 张梦皓 on 2020-05-02.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

protocol AuthenticationCoordinatorDelegate: AnyObject {
    func authenticationDidCancel(_ coordinator: AuthenticationCoordinator)
    func authentication(_ coordinator: AuthenticationCoordinator, didAuthenticateWith user: User)
    func authentication(_ coordinator: AuthenticationCoordinator, didFailWith error: Error)
}

final class AuthenticationCoordinator {
    weak var delegate: AuthenticationCoordinatorDelegate?
    
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
        // TODO: Just use a loading screen
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
                self.delegate?.authentication(self, didFailWith: error)
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
                self.delegate?.authentication(self, didFailWith: error)
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
                    self.delegate?.authentication(self, didAuthenticateWith: user)
                case .failure(let error):
                    self.delegate?.authentication(self, didFailWith: error)
                }
            }
        }
    }

    @objc private func dismissPresntedViewController(_ sender: Any) {
        navigationController.presentedViewController?.dismiss(animated: true)
    }
}

extension AuthenticationCoordinator: OnboardingContainerDelegate {
    func onboardingStopped(_ onboardingContainerViewController: OnboardingContainerViewController) {
        delegate?.authenticationDidCancel(self)
    }

    func onboardingFinished(_ onboardingContainerViewController: OnboardingContainerViewController) {
        // Noop
    }
}
