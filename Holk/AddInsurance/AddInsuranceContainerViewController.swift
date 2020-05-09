//
//  AddInsuranceContainerViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2020-05-04.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit
import Combine
protocol AddInsuranceContainerViewControllerDelegate: AnyObject {
    func addInsuranceDidFinish(_ viewController: AddInsuranceContainerViewController)
}

final class AddInsuranceContainerViewController: UIViewController{
    // MARK: - Public Variables
    var storeController: StoreController
    weak var delegate: AddInsuranceContainerViewControllerDelegate?

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
        progressBarToTop(animated: false)
        showInsuranceTypes()
    }

    private func setup() {
        NotificationCenter.default.addObserver(self, selector: #selector(resumeLoadingAnimation), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pauseLoadingAnimation), name: UIApplication.didEnterBackgroundNotification, object: nil)

        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = Color.mainBackgroundColor

        progressView.isHidden = true
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
}

extension AddInsuranceContainerViewController {
    private func showInsuranceTypes() {
        let insuranceProviderTypeViewController =
            AddInsuranceTypeViewController(storeController: storeController)
        insuranceProviderTypeViewController.delegate = self
        let barButton = UIBarButtonItem(
            image: UIImage(systemName: "xmark")?.withSymbolWeightConfiguration(.medium),
            style: .plain,
            target: self,
            action: #selector(stopAddingInsurance)
        )
        insuranceProviderTypeViewController.navigationItem.rightBarButtonItem = barButton
        childNavigationController.setViewControllers([insuranceProviderTypeViewController], animated: false)
    }

    @objc private func stopAddingInsurance(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension AddInsuranceContainerViewController {
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

extension AddInsuranceContainerViewController: AddInsuranceTypeViewControllerDelegate {
    func addInsuranceDidSelectProviderType(_ viewController: AddInsuranceTypeViewController, providerType: InsuranceProviderType) {
        self.providerType = providerType
        showInsuranceProviders()
    }

    private func showInsuranceProviders() {
        let viewController = AddInsuranceProviderViewController(storeController: storeController)
        viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark")?.withSymbolWeightConfiguration(.medium),
            style: .plain,
            target: self,
            action: #selector(stopAddingInsurance(_:))
        )
        viewController.delegate = self
        childNavigationController.pushViewController(viewController, animated: true)
    }
}

extension AddInsuranceContainerViewController: AddInsuranceProviderViewControllerDelegate {
    func addInsuranceDidSelectProvider(_ viewController: AddInsuranceProviderViewController, provider: InsuranceProvider) {
        self.insuranceProvider = provider
        guard let providerType = providerType else { fatalError("No providerType selected") }

        showConsent(with: providerType, provider: provider)
    }

    func showConsent(with providerType: InsuranceProviderType ,provider: InsuranceProvider) {
        let onboardingConsentViewController = AddInsuranceConsentViewController(storeController: storeController, insuranceProvider: provider, providerType: providerType)
        onboardingConsentViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark")?.withSymbolWeightConfiguration(.medium),
            style: .plain,
            target: self,
            action: #selector(stopAddingInsurance(_:))
        )
        onboardingConsentViewController.delegate = self
        childNavigationController.pushViewController(onboardingConsentViewController, animated: true)
    }
}

extension AddInsuranceContainerViewController: AddInsuranceConsentViewControllerDelegate {
    func addInsuranceDidSelectConsent(_ viewController: AddInsuranceConsentViewController) {
        guard let providerType = providerType, let insuranceProvider = insuranceProvider else {
            fatalError("insuranceProvider or providerType is null")
        }
        aggregateInsurance(providerType, insuranceProvider: insuranceProvider)
    }

    private func aggregateInsurance(_ providerType: InsuranceProviderType, insuranceProvider: InsuranceProvider) {
        progressSpinnerToCenter()
        storeController
            .insuranceCredentialStore
            .addInsurance(insuranceProvider)
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

    private func showInsuranceAggregatedConfirmation() {
        let confirmationViewController = AddInsuranceConfirmationViewController()
        confirmationViewController.delegate = self
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
}

extension AddInsuranceContainerViewController: AddInsuranceConfirmationViewControllerDelegate {
    func addInsuranceDidSelectFinish(_ viewController: AddInsuranceConfirmationViewController) {
        delegate?.addInsuranceDidFinish(self)
    }
}

extension AddInsuranceContainerViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let currentIndex = onboardingViewControllers.firstIndex(where: { viewController == $0 }) {
            progressView.currentStep = currentIndex + 1
        }
    }
}
