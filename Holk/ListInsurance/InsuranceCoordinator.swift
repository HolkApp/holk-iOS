//
//  InsuranceCoordinator.swift
//  Holk
//
//  Created by 张梦皓 on 2019-04-29.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

protocol InsuranceCoordinatorDelegate: AnyObject {
    func willShowInsuranceList(_ coordinator: InsuranceCoordinator)
    func didShowInsuranceList(_ coordinator: InsuranceCoordinator)
    func willHideInsuranceList(_ coordinator: InsuranceCoordinator)
    func didHideInsuranceList(_ coordinator: InsuranceCoordinator)
    func logout(_ coordinator: InsuranceCoordinator)
}

final class InsuranceCoordinator: NSObject {
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
        homeInsuranceViewController.hidesBottomBarWhenPushed = true
        navController.pushViewController(homeInsuranceViewController, animated: true)
    }

    func showInsuranceDetail(_ insurance: Insurance) {
        let homeInsuranceSubInsurancesViewController = HomeSubInsurancesViewController(storeController: storeController, insurance: insurance)
        navController.pushViewController(homeInsuranceSubInsurancesViewController, animated: true)
    }

    func showProfile() {
        let profileViewController = ProfileViewController(storeController: storeController)
        profileViewController.delegate = self
        profileViewController.hidesBottomBarWhenPushed = true
        navController.pushViewController(profileViewController, animated: true)
    }

    func logout() {
        delegate?.logout(self)
    }

    @objc private func back(_ sender: Any) {
        navController.popViewController(animated: true)
    }
}

// MARK: - UINavigationControllerDelegate
extension InsuranceCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        if fromVC is InsuranceListViewController, toVC is HomeInsuranceViewController {
//            return InsuranceTransition()
//        } else if fromVC is HomeInsuranceViewController, toVC is InsuranceListViewController {
//            return InsuranceTransition()
//        }
        return nil
    }

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController is InsuranceListViewController {
            delegate?.willShowInsuranceList(self)
        } else {
            delegate?.willHideInsuranceList(self)
        }
    }

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if viewController is InsuranceListViewController {
            delegate?.didShowInsuranceList(self)
        } else if viewController is HomeInsuranceViewController {
            delegate?.didHideInsuranceList(self)
        }
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

extension InsuranceCoordinator: ProfileViewControllerdelegate {
    func logout(_ profileViewController: ProfileViewController) {
        logout()
    }

    func delete(_ profileViewController: ProfileViewController) {
        storeController.userStore.delete { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.logout()
                case .failure(let error):
                    // TODO: Error handling
                    print(error)
                }
            }
        }
    }
}
