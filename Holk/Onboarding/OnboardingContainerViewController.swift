//
//  OnboardingContainerViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2020-02-07.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class OnboardingContainerViewController: UIViewController {
    // MARK: - Private Variables
    private let progressView = HolkProgressBarView()
    private let childNavigationController = UINavigationController()
    private var onboardingViewControllers: [UIViewController]
    private var progressViewTopAnchor: NSLayoutConstraint?
    private var progressViewHeightAnchor: NSLayoutConstraint?
    
    init(storeController: StoreController) {
        self.storeController = storeController
        onboardingViewControllers = []
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Variables
    weak var coordinator: OnboardingCoordinator?
    var storeController: StoreController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = Color.mainBackgroundColor
        
        progressView.totalSteps = 4
        progressView.currentStep = 1
        progressView.progressTintColor = Color.mainHighlightColor
        progressView.trackTintColor = Color.placeHolderColor
        progressView.setLoading(true)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        let insuranceProviderTypeVC = OnboardingInsuranceProviderTypeViewController(storeController: storeController)
        insuranceProviderTypeVC.navigationItem.setHidesBackButton(true, animated: false)
        let closeIcon = UIImage.fontAwesomeIcon(name: .times, style: .light, textColor: Color.mainForegroundColor, size: FontAwesome.mediumIconSize)
        insuranceProviderTypeVC.navigationItem.rightBarButtonItem = UIBarButtonItem(image: closeIcon, style: .plain, target: self, action: #selector(stopOnboarding(_:)))
        
        childNavigationController.setViewControllers([insuranceProviderTypeVC], animated: false)
        childNavigationController.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        childNavigationController.navigationBar.tintColor = .black
        childNavigationController.navigationBar.shadowImage = UIImage()
        
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
    
    func loadingFinished() {
        // TODO: Remove the wait after adding real polling
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.progressBarToTop()
        }
    }
    
    func startLoading() {
        progressSpinnerToCenter()
        childNavigationController.view.isHidden = true
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
        UIView.animate(withDuration: 0.3, animations: {
            self.progressViewTopAnchor?.constant = self.view.bounds.height / 2 - 100
            self.progressViewHeightAnchor?.constant = 150
        }) { _ in
            self.progressView.update(.spinner)
        }
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
                self?.coordinator?.back()
            })
        )
        present(alert, animated: true)
    }
}
