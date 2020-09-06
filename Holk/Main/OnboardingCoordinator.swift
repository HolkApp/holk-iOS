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

        onboardingContainerViewController.startOnboarding(user)
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
