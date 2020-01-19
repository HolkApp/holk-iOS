//
//  LoginCoordinator.swift
//  Holk
//
//  Created by 张梦皓 on 2019-04-30.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

protocol OnboardingCoordinatorDelegate: AnyObject {
    func didFinishOnboarding(coordinator: OnboardingCoordinator)
}

final class OnboardingCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    // MARK: - Public Properties
    var navController: UINavigationController
    var storeController: StoreController
    weak var delegate: OnboardingCoordinatorDelegate?
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
        
        let vc = OnboardingInsuranceProviderIssuerViewController(storeController: storeController)
        vc.coordinator = self
        navController.pushViewController(vc, animated: true)
    }
    
    func confirm(issuer: InsuranceIssuer? = nil, providerType: InsuranceProviderType? = nil) {
        if let issuer = issuer {
            storeController.insuranceStore.addInsurance(issuer: issuer, personalNumber: "199208253915")
        }
        
        let confirmedViewController = StoryboardScene.Onboarding.onboardingConfirmedViewController.instantiate()
        confirmedViewController.coordinator = self
        confirmedViewController.insuranceIssuer = issuer
        confirmedViewController.insuranceProviderType = providerType
        confirmedViewController.modalPresentationStyle = .overFullScreen
        navController.pushViewController(confirmedViewController, animated: false)
    }
    
    // MARK: - UINavigationControllerDelegate
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
        // check the fromVC if it is a sepecific VC then handle the navigation back action if needed
    }
    
    func finishOnboarding() {
        delegate?.didFinishOnboarding(coordinator: self)
    }
}
