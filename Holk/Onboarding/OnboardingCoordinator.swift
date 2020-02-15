//
//  LoginCoordinator.swift
//  Holk
//
//  Created by 张梦皓 on 2019-04-30.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit
import RxSwift

protocol OnboardingCoordinatorDelegate: AnyObject {
    func didFinishOnboarding(coordinator: OnboardingCoordinator)
}

final class OnboardingCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    // MARK: - Public Properties
    var navController: UINavigationController
    var storeController: StoreController
    weak var delegate: OnboardingCoordinatorDelegate?
    
    // MARK: - Private Properties
    private var bag = DisposeBag()
    private var onboardingContainerViewController: OnboardingContainerViewController?
    
    // MARK: - Init
    init(navController: UINavigationController, storeController: StoreController) {
        self.navController = navController
        self.storeController = storeController
    }
    
    // MARK: - Public Methods
    func start() {
        navController.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navController.navigationBar.shadowImage = UIImage()
        navController.delegate = self
        navController.navigationBar.tintColor = .black
        let onboardingContainerViewController = OnboardingContainerViewController(storeController: storeController)
        onboardingContainerViewController.coordinator = self
        self.onboardingContainerViewController = onboardingContainerViewController
        navController.setViewControllers([onboardingContainerViewController], animated: true)
    }
    
    func loadingFinished() {
        onboardingContainerViewController?.loadingFinished()
    }
    
    func confirm(issuer: InsuranceIssuer, providerType: InsuranceProviderType) {
        let confirmedViewController = StoryboardScene.Onboarding.onboardingConfirmedViewController.instantiate()
        confirmedViewController.coordinator = self
        confirmedViewController.insuranceIssuer = issuer
        confirmedViewController.insuranceProviderType = providerType
        confirmedViewController.modalPresentationStyle = .overFullScreen
        
        let loadingViewController = LoadingViewController()
        loadingViewController.modalPresentationStyle = .overFullScreen
        navController.present(loadingViewController, animated: true)
        
        storeController.insuranceCredentialStore.addInsurance(issuer: issuer, personalNumber: "199208253915")
        storeController.insuranceCredentialStore.insuranceState
            .subscribe({ [weak self] event in
                switch event {
                case .next(let state):
                    switch state {
                        // TOOD: Error handling
                    case .loaded, .error:
                        self?.navController.pushViewController(confirmedViewController, animated: false)
                        self?.navController.dismiss(animated: true)
                    case .loading, .unintiated:
                        break
                    }
                default:
                    break
                }
            })
            .disposed(by: bag)
    }
    
    func finishOnboarding() {
        delegate?.didFinishOnboarding(coordinator: self)
    }
}
