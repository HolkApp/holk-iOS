//
//  OnboardingContainerViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2020-02-07.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit
import RxSwift

protocol OnboardingCoordinating: AnyObject {
    func startLoading()
    func loadingFinished()
    func startOnboarding()
    func addInsuranceProviderType(_ providerType: InsuranceProviderType)
    func addInsuranceIssuer(_ insuranceIssuer: InsuranceIssuer)
    func aggregateInsurance(_ providerType: InsuranceProviderType, insuranceIssuer: InsuranceIssuer)
    func finishOnboarding()
}

final class OnboardingContainerViewController: UIViewController {
    // MARK: - Private Variables
    private var bag = DisposeBag()
    private let progressView = HolkProgressBarView()
    private let childNavigationController = UINavigationController()
    private var onboardingViewControllers: [UIViewController] {
        childNavigationController.viewControllers
    }
    private var progressViewTopAnchor: NSLayoutConstraint?
    private var progressViewHeightAnchor: NSLayoutConstraint?
    private var providerType: InsuranceProviderType?
    private var insuranceIssuer: InsuranceIssuer?

    // MARK: - Public Variables
    var storeController: StoreController
    weak var coordinator: SessionCoordinator?
    
    init(storeController: StoreController) {
        self.storeController = storeController
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = Color.mainBackgroundColor
        
        progressView.totalSteps = 4
        progressView.progressTintColor = Color.mainHighlightColor
        progressView.trackTintColor = Color.placeHolderColor
        
        childNavigationController.delegate = self
        childNavigationController.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        childNavigationController.navigationBar.tintColor = .black
        childNavigationController.navigationBar.shadowImage = UIImage()
        
        setupConstraints()
        startOnboarding()
    }
    
    private func setupConstraints() {
        progressView.translatesAutoresizingMaskIntoConstraints = false
        childNavigationController.view.translatesAutoresizingMaskIntoConstraints = false
        
        addChild(childNavigationController)
        view.addSubview(childNavigationController.view)
        childNavigationController.didMove(toParent: self)
        childNavigationController.view.isHidden = true
        
        view.addSubview(progressView)
        let progressViewTopAnchor = progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.bounds.height / 2 - 100)
        let progressViewHeightAnchor = progressView.heightAnchor.constraint(equalToConstant: 150)
        
        self.progressViewTopAnchor = progressViewTopAnchor
        self.progressViewHeightAnchor = progressViewHeightAnchor
        NSLayoutConstraint.activate([
            progressView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progressViewTopAnchor,
            progressViewHeightAnchor,
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            childNavigationController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            childNavigationController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            childNavigationController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            childNavigationController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func stopOnboarding(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure you want to cancel", message: nil, preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                alert.dismiss(animated: true)
            })
        )
        alert.addAction(
            UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
                self?.dismiss(animated: true) {
                    self?.dismiss(animated: true)
                }
            })
        )
        present(alert, animated: true)
    }
}

extension OnboardingContainerViewController: OnboardingCoordinating {
    func startLoading() {
        progressSpinnerToCenter()
        childNavigationController.view.isHidden = true
    }
    
    func loadingFinished() {
        storeController.insuranceIssuerStore.loadInsuranceIssuers()
        // TODO: Remove the wait after adding real polling
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.progressBarToTop()
        }
    }
    
    func startOnboarding() {
        startLoading()
        let insuranceProviderTypeViewController = OnboardingInsuranceTypeViewController(storeController: storeController)
        insuranceProviderTypeViewController.coordinator = self
        insuranceProviderTypeViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark")?.withSymbolWeightConfiguration(.medium),
            style: .plain,
            target: self,
            action: #selector(stopOnboarding(_:))
        )
        childNavigationController.setViewControllers([insuranceProviderTypeViewController], animated: false)
    }
    
    func addInsuranceProviderType(_ providerType: InsuranceProviderType) {
        self.providerType = providerType
        let viewController = OnboardingInsuranceIssuerViewController(storeController: storeController)
        viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark")?.withSymbolWeightConfiguration(.medium),
            style: .plain,
            target: self,
            action: #selector(stopOnboarding(_:))
        )
        viewController.coordinator = self
        childNavigationController.pushViewController(viewController, animated: true)
    }
    
    func addInsuranceIssuer(_ insuranceIssuer: InsuranceIssuer) {
        guard let providerType = providerType else { fatalError("No providerType selected") }
        self.insuranceIssuer = insuranceIssuer
        let onboardingConsentViewController = OnboardingConsentViewController(storeController: storeController, insuranceIssuer: insuranceIssuer, providerType: providerType)
        onboardingConsentViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark")?.withSymbolWeightConfiguration(.medium),
            style: .plain,
            target: self,
            action: #selector(stopOnboarding(_:))
        )
        onboardingConsentViewController.coordinator = self
        childNavigationController.pushViewController(onboardingConsentViewController, animated: true)
    }
    
    func aggregateInsurance(_ providerType: InsuranceProviderType, insuranceIssuer: InsuranceIssuer) {
        startLoading()
        storeController.insuranceCredentialStore.addInsurance(issuer: insuranceIssuer, personalNumber: "199208253915")
        storeController.insuranceCredentialStore.insuranceState
            .subscribe({ [weak self] event in
                switch event {
                case .next(let state):
                    switch state {
                    case .loaded(let scrapingStatus):
                        print(scrapingStatus)
                        self?.showInsuranceAggregatedConfirmation(insuranceIssuer)
                        self?.loadingFinished()
                    case .error:
                        // TOOD: Error handling
                        print(state)
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
        coordinator?.finishOnboarding(coordinator: self)
    }
    
    private func showInsuranceAggregatedConfirmation(_ insuranceIssuer: InsuranceIssuer) {
        let confirmationViewController = OnboardingConfirmationViewController(insuranceIssuer: insuranceIssuer)
        confirmationViewController.coordinator = self
        childNavigationController.pushViewController(confirmationViewController, animated: true)
    }
    
    private func progressBarToTop() {
        progressView.update(.bar, animated: true) { [weak self] in
            guard let self = self else { return }
            UIView.animate(withDuration: 0.3, animations: {
                self.progressViewTopAnchor?.constant = 40
                self.progressViewHeightAnchor?.constant = 40
                self.view.layoutIfNeeded()
            }) { _ in
                self.childNavigationController.view.isHidden = false
            }
        }
    }
    
    private func progressSpinnerToCenter() {
        progressViewTopAnchor?.constant = view.bounds.height / 2 - 100
        progressViewHeightAnchor?.constant = 150
        progressView.update(.spinner, animated: false)
    }
}

extension OnboardingContainerViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let currentIndex = onboardingViewControllers.firstIndex(where: { viewController == $0 }) {
            progressView.currentStep = currentIndex + 1
        }
    }
}
