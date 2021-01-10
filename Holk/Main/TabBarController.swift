//
//  TabBarController.swift
//  Holk
//
//  Created by 张梦皓 on 2019-04-30.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

final class TabBarController: UITabBarController {
    // MARK: - Public variables
    weak var coordinator: SessionCoordinator?
    
    // MARK: - Private variables
    private lazy var insuranceCoordinator = InsuranceCoordinator(storeController: storeController)
    private lazy var protectionCoordinator = InsuranceProtectionCoordinator()
    private var storeController: StoreController
    private let addMoreButton = HolkButton()
    private var addMoreButtonCenterXAnchor: NSLayoutConstraint?
    private var addMoreButtonTopAnchor: NSLayoutConstraint?

    init(storeController: StoreController) {
        self.storeController = storeController

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        insuranceCoordinator.start()
        insuranceCoordinator.delegate = self
        
        protectionCoordinator.start()

        viewControllers = [
            insuranceCoordinator.navController,
            protectionCoordinator.navController
        ]

        tabBar.barTintColor = Color.mainBackground
        tabBar.unselectedItemTintColor = Color.mainForeground
        tabBar.tintColor = Color.secondaryHighlight

        let addMoreImage = UIImage(systemName: "plus")?.withSymbolWeightConfiguration(.regular, pointSize: 30)
        addMoreButton.set(color: Color.mainBackground, image: addMoreImage)
        addMoreButton.addTarget(self, action: #selector(addMoreTapped(sender:)), for: .touchUpInside)
        addMoreButton.backgroundColor = Color.secondaryHighlight
        addMoreButton.layer.cornerRadius = 20
        addMoreButton.clipsToBounds = true
        addMoreButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(addMoreButton)

        NSLayoutConstraint.activate([
            addMoreButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addMoreButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -4),
            addMoreButton.widthAnchor.constraint(equalToConstant: 40),
            addMoreButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        view.bringSubviewToFront(addMoreButton)
    }

    private func addMoreInsurance() {
        let addInsuranceContainerViewController = AddInsuranceContainerViewController(storeController: storeController)
        addInsuranceContainerViewController.delegate = self
        present(addInsuranceContainerViewController, animated: true)
    }

    @objc private func addMoreTapped(sender: UIButton) {
        addMoreInsurance()
    }
}

// TODO: Change this when have a real profile
extension TabBarController: InsuranceCoordinatorDelegate {
    func willShowInsuranceList(_ coordinator: InsuranceCoordinator) {
        addMoreButton.isHidden = false
    }

    func willHideInsuranceList(_ coordinator: InsuranceCoordinator) {
        addMoreButton.isHidden = true
    }

    func didShowInsuranceList(_ coordinator: InsuranceCoordinator) {
        view.bringSubviewToFront(addMoreButton)
    }

    func addMoreInsurance(_ coordinator: InsuranceCoordinator) {
        addMoreInsurance()
    }

    func logout(_ coordinator: InsuranceCoordinator) {
        self.coordinator?.logout()
    }

    func deleteAccount(_ coordinator: InsuranceCoordinator) {
        self.coordinator?.deleteAccount()
    }
}

extension TabBarController: AddInsuranceContainerViewControllerDelegate {
    func addInsuranceDidFinish(_ viewController: AddInsuranceContainerViewController) {
        viewController.dismiss(animated: true)
    }
}
