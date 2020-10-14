//
//  OnboardingCoordinator.swift
//  Holk
//
//  Created by 张梦皓 on 2020-09-06.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

protocol OnboardingCoordinatorDelegate: AnyObject {
    func onboardingStopped(_ coordinator: OnboardingCoordinator)
    func onboardingFinished(_ coordinator: OnboardingCoordinator)
}

final class OnboardingCoordinator {
    weak var delegate: OnboardingCoordinatorDelegate?

    private var navigationController: UINavigationController
    private var newUserViewController: NewUserViewController?
    private var storeController: StoreController
    private var user: User
    private var onboardingContainerViewController: OnboardingContainerViewController

    init(navigationController: UINavigationController, storeController: StoreController, user: User) {
        self.navigationController = navigationController
        self.storeController = storeController
        self.user = user
        self.onboardingContainerViewController = OnboardingContainerViewController(storeController: storeController)
    }

    func start() {
        onboardingContainerViewController.delegate = self
        navigationController.pushViewController(onboardingContainerViewController, animated: false)

        if user.isNewUser {
            showAddNewUser(user)
        } else {
            onboardingContainerViewController.start()
        }
    }

    private func showAddNewUser(_ user: User) {
        let newUserViewController = NewUserViewController(user: user)
        newUserViewController.delegate = self
        self.newUserViewController = newUserViewController

        onboardingContainerViewController.addSubViewController(newUserViewController)
    }
}

extension OnboardingCoordinator: NewUserViewControllerDelegate {
     func newUserViewController(_ viewController: NewUserViewController, add email: String) {
        onboardingContainerViewController.progressSpinnerToCenter()
        newUserViewController?.removeFromParent()
        newUserViewController?.view.removeFromSuperview()

        storeController.userStore.addEmail(email) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.onboardingContainerViewController.progressBarToTop()
                    self.onboardingContainerViewController.start()
                }
            case .failure(let error):
                // TODO: remove this
                self.onboardingContainerViewController.showError(error, requestName: "authorize/user/email")
            }
        }
    }
}

extension OnboardingCoordinator: OnboardingContainerDelegate {
    func onboardingStopped(_ onboardingContainerViewController: OnboardingContainerViewController) {
        delegate?.onboardingStopped(self)
    }
    func onboardingFinished(_ onboardingContainerViewController: OnboardingContainerViewController) {
        delegate?.onboardingFinished(self)
    }
}
