//
//  HomeinsuranceSubInsurancesViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2020-07-01.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class HomeSubInsurancesViewController: UIViewController {
    enum Section: CaseIterable {
        case subInsurance
    }

    enum HomeSubInsuranceSegment: Hashable {
        case basic(Insurance.Segment)
        case additional(Insurance.Segment)
    }

    enum SubInsuranceSegment {
        case basic
        case additional
    }

    typealias DataSource = UICollectionViewDiffableDataSource<Section, HomeSubInsuranceSegment>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, HomeSubInsuranceSegment>

    // MARK: - Public Variables
    var storeController: StoreController

    // MARK: - Private Variables
    private let insurance: Insurance
    private let basicSubInsurances: [HomeSubInsuranceSegment]
    private let additionalSubInsurances: [HomeSubInsuranceSegment]
    private var selectedSegment: SubInsuranceSegment = .basic
    private lazy var dataSource = makeDataSource()
    private lazy var collectionView: UICollectionView = {
        let layout = makeSubinsurancesLayout()
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()

    // MARK: - Init
    init(storeController: StoreController, insurance: Insurance) {
        self.storeController = storeController
        self.insurance = insurance
        basicSubInsurances = insurance.segments.compactMap { HomeSubInsuranceSegment.basic($0) }
        // TODO: Update this
        additionalSubInsurances = []

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        applySnapshot(animatingDifferences: false)
    }

    func updateSelection(_ segment: SubInsuranceSegment) {
        selectedSegment = segment
        applySnapshot()
    }

    private func setup() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.setAppearance(backgroundColor: Color.secondaryBackground)

        collectionView.bounces = false
        collectionView.backgroundColor = Color.insuranceBackground
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.registerCell(SubInsuranceCollectionViewCell.self)
        collectionView.registerReusableSupplementaryView(SubInsuranceHeaderView.self, of: UICollectionView.elementKindSectionHeader)
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: UICollectionViewLayout
extension HomeSubInsurancesViewController {
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, segment) in
                switch segment {
                case .basic(let basicSegment):
                    let subInsuranceCollectionViewCell = collectionView.dequeueCell(SubInsuranceCollectionViewCell.self, indexPath: indexPath)
                    subInsuranceCollectionViewCell.configure(basicSegment)
                    return subInsuranceCollectionViewCell
                case .additional(let additionalSegment):
                    let subInsuranceCollectionViewCell = collectionView.dequeueCell(SubInsuranceCollectionViewCell.self, indexPath: indexPath)
                    subInsuranceCollectionViewCell.configure(additionalSegment)
                    return subInsuranceCollectionViewCell
                }
        })
        dataSource.supplementaryViewProvider = ({ [weak self] (collectionView, kind, indexPath) in
            guard let self = self else { return nil }
            if kind == UICollectionView.elementKindSectionHeader {
                let subInsuranceHeaderView = collectionView.dequeueReusableSupplementaryView(
                    SubInsuranceHeaderView.self,
                    of: kind, indexPath: indexPath
                )
                subInsuranceHeaderView.configure(self.insurance)
                subInsuranceHeaderView.subInsurancesViewController = self
                return subInsuranceHeaderView
            } else {
                return nil
            }
        })
        return dataSource
    }

    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        let sections = Section.allCases
        snapshot.appendSections(sections)
        switch selectedSegment {
        case .basic:
            snapshot.appendItems(basicSubInsurances)
        case .additional:
            snapshot.appendItems(additionalSubInsurances)
        }

        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

    private func makeSubinsurancesLayout() -> UICollectionViewLayout {
        let sections = [makeSubInsuranceCardsSection()]

        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) in
            return sections[sectionIndex]
        }
        return layout
    }

    private func makeSubInsuranceSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(260))
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return headerElement
    }

    private func makeSubInsuranceCardsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
        let cardSection = NSCollectionLayoutSection(group: group)
        cardSection.interGroupSpacing = 24
        cardSection.contentInsets = .init(top: 40, leading: 0, bottom: 20, trailing: 0)
        cardSection.boundarySupplementaryItems = [makeSubInsuranceSectionHeader()]
        return cardSection
    }
}
