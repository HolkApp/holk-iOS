//
//  InsuranceCoordinator.swift
//  Holk
//
//  Created by 张梦皓 on 2019-04-29.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

protocol InsuranceCoordinatorDelegate: AnyObject {
    func logout(_ coordinator: InsuranceCoordinator)
}

final class InsuranceCoordinator: NSObject, UINavigationControllerDelegate {
    // MARK: - Public Variables
    var storeController: StoreController
    weak var delegate: InsuranceCoordinatorDelegate?
    let navController = UINavigationController()

    // MARK: - Init
    init(storeController: StoreController) {
        self.storeController = storeController
    }
    // MARK: - Public Methods
    func start() {
        // Move the layout into the `InsuranceListViewController`
        let layout = makeInsuranceListLayout()
        let insuranceListViewController = InsuranceListViewController(storeController: storeController, collectionViewLayout: layout)
        insuranceListViewController.coordinator = self

        navController.navigationBar.prefersLargeTitles = true
        navController.tabBarItem = UITabBarItem(title: "Översikt", image: UIImage(systemName: "square.stack.3d.up"), selectedImage: UIImage(systemName: "square.stack.3d.up.fill"))
        navController.delegate = self
        navController.pushViewController(insuranceListViewController, animated: false)
    }

    func showInsurance(_ insurance: Insurance) {
        let homeInsuranceViewController = HomeInsuranceViewController(storeController: storeController, insurance: insurance)
        homeInsuranceViewController.coordinator = self
        navController.pushViewController(homeInsuranceViewController, animated: true)
    }

    func showinsuranceDetail(_ insurance: Insurance) {
        let homeinsuranceSubInsurancesViewController = HomeSubInsurancesViewController(storeController: storeController, insurance: insurance)
        navController.pushViewController(homeinsuranceSubInsurancesViewController, animated: true)
    }

    func logout() {
        delegate?.logout(self)
    }

    @objc private func back(_ sender: Any) {
        navController.popViewController(animated: true)
    }
    
    // MARK: - UINavigationControllerDelegate
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if fromVC is InsuranceListViewController, toVC is HomeInsuranceViewController {
            return InsuranceTransition()
        } else if fromVC is HomeInsuranceViewController, toVC is InsuranceListViewController {
            return InsuranceTransition()
        }
        return nil
    }
}

extension InsuranceCoordinator {
    private func makeInsuranceListLayout() -> UICollectionViewLayout {
        let sections = [makeSuggestionSection(), makeInsuranceListSection()]

        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) in
            return sections[sectionIndex]
        }
        return layout
    }

    private func makeSuggestionSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .estimated(80))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(80))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let suggestionSection = NSCollectionLayoutSection(group: group)
        suggestionSection.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
        return suggestionSection
    }

    private func makeInsuranceListSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(400))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(360))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let cardSection = NSCollectionLayoutSection(group: group)
        cardSection.interGroupSpacing = 24
        cardSection.contentInsets = .init(top: 12, leading: 16, bottom: 0, trailing: 16)
        return cardSection
    }
}
