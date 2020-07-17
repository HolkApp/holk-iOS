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
    private let insuranceCoordinator: InsuranceCoordinator
    private let protectionCoordinator: InsuranceProtectionCoordinator
    private var storeController: StoreController
    private let addMoreButton = HolkButton()

    init(storeController: StoreController) {
        self.storeController = storeController
        insuranceCoordinator = InsuranceCoordinator(storeController: storeController)
        protectionCoordinator = InsuranceProtectionCoordinator()

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
        
        tabBar.barTintColor = Color.secondaryBackground
        tabBar.unselectedItemTintColor = Color.mainForeground
        tabBar.tintColor = Color.secondaryHighlight

        let addMoreImage = UIImage(systemName: "plus")?.withSymbolWeightConfiguration(.regular, pointSize: 30)
        addMoreButton.set(color: Color.secondaryBackground, image: addMoreImage)
        addMoreButton.addTarget(self, action: #selector(addMoreTapped(sender:)), for: .touchUpInside)
        addMoreButton.backgroundColor = Color.secondaryHighlight
        addMoreButton.layer.cornerRadius = 26
        addMoreButton.clipsToBounds = true
        addMoreButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(addMoreButton)

        NSLayoutConstraint.activate([
            addMoreButton.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
            addMoreButton.centerYAnchor.constraint(equalTo: tabBar.topAnchor),
            addMoreButton.widthAnchor.constraint(equalToConstant: 52),
            addMoreButton.heightAnchor.constraint(equalToConstant: 52)
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

    @objc private func addMoreTapped(sender: UIButton) {
        let addInsuranceContainerViewController = AddInsuranceContainerViewController(storeController: storeController)
        addInsuranceContainerViewController.delegate = self
        present(addInsuranceContainerViewController, animated: true)
    }
}

// TODO: Change this when have a real profile
extension TabBarController: InsuranceCoordinatorDelegate {
    func logout(_ coordinator: InsuranceCoordinator) {
        self.coordinator?.logout()
    }
}

extension TabBarController: AddInsuranceContainerViewControllerDelegate {
    func addInsuranceDidFinish(_ viewController: AddInsuranceContainerViewController) {
        viewController.dismiss(animated: true)
    }
}
