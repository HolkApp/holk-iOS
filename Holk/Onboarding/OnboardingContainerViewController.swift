//
//  OnboardingContainerViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2020-02-07.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit
import Combine

protocol OnboardingCoordinating: AnyObject {
    func startOnboarding(_ user: User)
    func addInsuranceProviderType(_ providerType: InsuranceProviderType)
    func addInsuranceProvider(_ provider: InsuranceProvider)
    func aggregateInsurance(_ providerType: InsuranceProviderType, insuranceProvider: InsuranceProvider)
    func finishOnboarding()
}

final class OnboardingContainerViewController: UIViewController {
    // MARK: - Private Variables
    private let progressView = HolkProgressBarView()
    private let childNavigationController = UINavigationController()
    private var onboardingViewControllers: [UIViewController] {
        childNavigationController.viewControllers
    }
    private var progressViewTopAnchor: NSLayoutConstraint?
    private var progressViewHeightAnchor: NSLayoutConstraint?
    private var providerType: InsuranceProviderType?
    private var insuranceProvider: InsuranceProvider?
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Public Variables
    var storeController: StoreController
    weak var coordinator: OnboardingCoordinator?
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(resumeLoadingAnimation), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pauseLoadingAnimation), name: UIApplication.didEnterBackgroundNotification, object: nil)

        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = Color.mainBackgroundColor
        
        progressView.totalSteps = 4
        progressView.progressTintColor = Color.mainHighlightColor
        progressView.trackTintColor = Color.placeHolderColor
        
        childNavigationController.delegate = self
        childNavigationController.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        childNavigationController.navigationBar.tintColor = .black
        childNavigationController.navigationBar.shadowImage = UIImage()
        
        setupLayout()
    }
    
    private func setupLayout() {
        progressView.translatesAutoresizingMaskIntoConstraints = false
        childNavigationController.view.translatesAutoresizingMaskIntoConstraints = false
        
        addChild(childNavigationController)
        view.addSubview(childNavigationController.view)
        childNavigationController.didMove(toParent: self)
        
        view.addSubview(progressView)
        let progressViewTopAnchor = progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.bounds.height / 2 - 100)
        let progressViewHeightAnchor = progressView.heightAnchor.constraint(equalToConstant: 150)
        
        self.progressViewTopAnchor = progressViewTopAnchor
        self.progressViewHeightAnchor = progressViewHeightAnchor
        NSLayoutConstraint.activate([
            childNavigationController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            childNavigationController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            childNavigationController.view.topAnchor.constraint(equalTo: view.topAnchor),
            childNavigationController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            progressView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progressViewTopAnchor,
            progressViewHeightAnchor,
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
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
                guard let self = self else { return }
                alert.dismiss(animated: true) {
                    self.coordinator?.onboardingStopped(self)
                }
            })
        )
        present(alert, animated: true)
    }
}

extension OnboardingContainerViewController: OnboardingCoordinating {
    func startOnboarding(_ user: User) {
        progressView.isHidden = true
        // TODO: Dont show new user if it is not new
        showAddNewUser(user)
//        if user.isNewUser {
//            showAddNewUser(user)
//        } else {
//            progressBarToTop(animated: false, completion: { [weak self] in
//                self?.showInsuranceType()
//            })
//        }
    }

    private func showAddNewUser(_ user: User) {
        let newUserViewController = NewUserViewController(user: user)
        newUserViewController.delegate = self
        let barButton = UIBarButtonItem(
            image: UIImage(systemName: "xmark")?.withSymbolWeightConfiguration(.medium),
            style: .plain,
            target: self,
            action: #selector(stopOnboarding(_:))
        )
        newUserViewController.navigationItem.rightBarButtonItem = barButton
        childNavigationController.setViewControllers([newUserViewController], animated: true)
    }

    private func showInsuranceType() {
        let insuranceProviderTypeViewController = OnboardingInsuranceTypeViewController(storeController: storeController)
        insuranceProviderTypeViewController.coordinator = self
        let barButton = UIBarButtonItem(
            image: UIImage(systemName: "xmark")?.withSymbolWeightConfiguration(.medium),
            style: .plain,
            target: self,
            action: #selector(stopOnboarding(_:))
        )
        insuranceProviderTypeViewController.navigationItem.rightBarButtonItem = barButton
        childNavigationController.setViewControllers([insuranceProviderTypeViewController], animated: false)
    }
    
    func addInsuranceProviderType(_ providerType: InsuranceProviderType) {
        self.providerType = providerType
        let viewController = OnboardingInsuranceProviderViewController(storeController: storeController)
        viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark")?.withSymbolWeightConfiguration(.medium),
            style: .plain,
            target: self,
            action: #selector(stopOnboarding(_:))
        )
        viewController.coordinator = self
        childNavigationController.pushViewController(viewController, animated: true)
    }
    
    func addInsuranceProvider(_ provider: InsuranceProvider) {
        guard let providerType = providerType else { fatalError("No providerType selected") }
        self.insuranceProvider = provider
        let onboardingConsentViewController = OnboardingConsentViewController(storeController: storeController, insuranceProvider: provider, providerType: providerType)
        onboardingConsentViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark")?.withSymbolWeightConfiguration(.medium),
            style: .plain,
            target: self,
            action: #selector(stopOnboarding(_:))
        )
        onboardingConsentViewController.coordinator = self
        childNavigationController.pushViewController(onboardingConsentViewController, animated: true)
    }
    
    func aggregateInsurance(_ providerType: InsuranceProviderType, insuranceProvider: InsuranceProvider) {
        progressSpinnerToCenter()
        storeController
            .insuranceCredentialStore
            .addInsurance(insuranceProvider, personalNumber: storeController.user.personalNumber)
        storeController
            .insuranceCredentialStore
            .insuranceStatus.sink { [weak self] scrapingStatus in
            print(scrapingStatus)
            switch scrapingStatus {
            case .completed:
                self?.showInsuranceAggregatedConfirmation()
                self?.progressBarToTop()
            default:
                break
            }
        }.store(in: &cancellables)
    }
    
    func finishOnboarding() {
        coordinator?.onboardingFinished(self)
    }

    private func showInsuranceAggregatedConfirmation() {
        let confirmationViewController = OnboardingConfirmationViewController()
        confirmationViewController.coordinator = self
        childNavigationController.pushViewController(confirmationViewController, animated: true)
        storeController.insuranceStore.fetchAllInsurances { result in
            // TODO Need to change this with real data
            switch result {
            case .success(let allInsuranceResponse):
                confirmationViewController.addedInsurance = allInsuranceResponse.insuranceList.first
            case .failure(let error):
                confirmationViewController.addedInsurance = AllInsuranceResponse.mockInsurnace
                print(error)
                break
            }
        }
    }
    
    private func progressBarToTop(animated: Bool = true, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.progressView.update(.bar, animated: animated) {
                if animated {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.progressViewTopAnchor?.constant = 40
                        self.progressViewHeightAnchor?.constant = 40
                        self.view.layoutIfNeeded()
                    }) { _ in
                        self.childNavigationController.view.isHidden = false
                        self.progressView.isHidden = false
                        completion?()
                    }
                } else {
                    self.progressViewTopAnchor?.constant = 40
                    self.progressViewHeightAnchor?.constant = 40
                    self.childNavigationController.view.isHidden = false
                    self.progressView.isHidden = false
                    completion?()
                }
            }
        }
    }
    
    private func progressSpinnerToCenter() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.progressViewTopAnchor?.constant = self.view.bounds.height / 2 - 100
            self.progressViewHeightAnchor?.constant = 150
            self.progressView.update(.spinner, animated: false)
            self.childNavigationController.view.isHidden = true
        }
    }

    @objc private func pauseLoadingAnimation() {
        guard !progressView.isHidden else { return }
        progressView.setLoading(false)
    }

    @objc private func resumeLoadingAnimation() {
        guard !progressView.isHidden else { return }
        progressView.setLoading(true)
    }
}

extension OnboardingContainerViewController: NewUserViewControllerDelegate {
    func newUserViewController(_ viewController: NewUserViewController, add email: String) {
        // TODO: update this
        progressView.setLoading(true)
        childNavigationController.view.isHidden = true
        progressView.isHidden = false

        storeController.userStore.addEmail(email) { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self?.showInsuranceType()
                    self?.progressBarToTop()
                }
            case .failure(let error):
                print(error)
                break
            }
        }
    }
}

extension OnboardingContainerViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let currentIndex = onboardingViewControllers.firstIndex(where: { viewController == $0 }) {
            progressView.currentStep = currentIndex + 1
        }
    }
}
