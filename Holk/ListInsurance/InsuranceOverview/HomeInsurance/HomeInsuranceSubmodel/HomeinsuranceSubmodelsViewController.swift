//
//  HomeinsuranceSubmodelDetailViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2020-07-01.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class HomeinsuranceSubmodelsViewController: UIViewController {
    // MARK: - Public Variables
    var storeController: StoreController

    // MARK: - Private Variables
    private lazy var collectionView: UICollectionView = {
        let onboardingLayoutSection = UICollectionViewCompositionalLayout.makeOnboardingViewSection()
        let layout = UICollectionViewCompositionalLayout(section: onboardingLayoutSection)
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()

    // MARK: - Init
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
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

// MARK: UICollectionViewLayout
extension HomeinsuranceSubmodelDetailViewController {
    static func makeSubinsurancesLayout() -> UICollectionViewLayout {
        // makeSumodelCardsSection()
        let sections = [makeSubmodelSegmentedSection()]

        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) in
            return sections[sectionIndex]
        }
        return layout
    }

    static func makeSubmodelSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(260))
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return headerElement
    }

    static func makeSubmodelSegmentedSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(130), heightDimension: .estimated(72))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(72))

        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 2)
        let cardSection = NSCollectionLayoutSection(group: group)
        cardSection.interGroupSpacing = 32
        cardSection.boundarySupplementaryItems = [makeSubmodelSectionHeader()]
        cardSection.contentInsets = .init(top: 0, leading: 48, bottom: 0, trailing: 48)
        return cardSection
    }

    static func makeSumodelCardsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(420))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(420))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let cardSection = NSCollectionLayoutSection(group: group)
        cardSection.interGroupSpacing = 24
        cardSection.boundarySupplementaryItems = [makeSubinsurancesSectionHeader()]
        cardSection.contentInsets = .init(top: 36, leading: 16, bottom: 0, trailing: 16)
        return cardSection
    }
}
