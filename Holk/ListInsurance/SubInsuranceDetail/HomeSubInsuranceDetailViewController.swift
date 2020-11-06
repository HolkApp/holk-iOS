//
//  HomeSubInsuranceDetailViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2020-10-11.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

enum SelectedSubInsuranceDetails {
    case cover
    case gaps
    case thinkOfs
}

final class HomeSubInsuranceDetailViewController: UIViewController {
    enum Section: CaseIterable {
        case title
        case detailsItem
    }

    enum SubInsuranceDetailsItem: Hashable {
        case title
        case cover
        case gap
        case thinkOf
    }

    private enum SelectedSubInsuranceCoverSegment {
        case primary
        case secondary
    }

    // MARK: - Private Variables
    private var storeController: StoreController
    private var insurance: Insurance
    private var subInsurance: Insurance.SubInsurance
    private var selectedSubInsuranceDetails: SelectedSubInsuranceDetails = .cover
    private var selectedSubInsuranceCoverSegment: SelectedSubInsuranceCoverSegment = .primary
    private lazy var dataSource = makeDataSource()

    typealias DataSource = UICollectionViewDiffableDataSource<Section, SubInsuranceDetailsItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, SubInsuranceDetailsItem>

    private lazy var collectionView: UICollectionView = {
        let layout = makeDetailLayout()
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()

    init(storeController: StoreController, insurance: Insurance, subInsurance: Insurance.SubInsurance) {
        self.storeController = storeController
        self.insurance = insurance
        self.subInsurance = subInsurance

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

    private func setup() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.setAppearance()

        // Quick fix, since setting contentInsetAdjustmentBehavior to false will break the layout
        collectionView.contentInset.top = -(navigationBarHeight + statusBarHeight)
        collectionView.contentInset.bottom = 40
        collectionView.backgroundColor = Color.mainBackground
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.registerCell(SubInsuranceDetailsTitleCollectionViewCell.self)
        collectionView.registerCell(SubInsuranceDetailsItemCollectionViewCell.self)
        collectionView.registerReusableSupplementaryView(SubInsuranceDetailsHeaderView.self, of: UICollectionView.elementKindSectionHeader)
        collectionView.registerReusableSupplementaryView(SubInsuranceDetailsSegmentHeaderView.self, of: UICollectionView.elementKindSectionHeader)
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UICollectionView layout
extension HomeSubInsuranceDetailViewController {
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        let sections = Section.allCases
        snapshot.appendSections(sections)
        sections.forEach { section in
            if section == .title {
                snapshot.appendItems([.title], toSection: section)
            } else {
                switch selectedSubInsuranceDetails {
                case .cover:
                    // TODO: Check the segment and add different snapshot
                    if selectedSubInsuranceCoverSegment == .primary {
                        snapshot.appendItems([.cover], toSection: section)
                    } else {
                        snapshot.appendItems([.cover], toSection: section)
                    }
                case .gaps:
                    snapshot.appendItems([.gap], toSection: section)
                case .thinkOfs:
                    snapshot.appendItems([.thinkOf], toSection: section)
                }
            }
        }
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

    private func makeDataSource() -> DataSource {
        // TODO:
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, subInsuranceDetailsItem) in
                switch subInsuranceDetailsItem {
                case .title:
                    let subInsuranceDetailsTitleCollectionViewCell = collectionView.dequeueCell(
                        SubInsuranceDetailsTitleCollectionViewCell.self,
                        indexPath: indexPath
                    )
                    subInsuranceDetailsTitleCollectionViewCell.configure("Ditt skydd")
                    return subInsuranceDetailsTitleCollectionViewCell
                case .cover:
                    let subInsuranceDetailsItemCollectionViewCell = collectionView.dequeueCell(
                        SubInsuranceDetailsItemCollectionViewCell.self,
                        indexPath: indexPath
                    )
                    subInsuranceDetailsItemCollectionViewCell.configure(self.subInsurance.items[indexPath.item])
                    return subInsuranceDetailsItemCollectionViewCell
                case .gap:
                    let subInsuranceDetailsItemCollectionViewCell = collectionView.dequeueCell(
                        SubInsuranceDetailsItemCollectionViewCell.self,
                        indexPath: indexPath
                    )
                    return subInsuranceDetailsItemCollectionViewCell
                case .thinkOf:
                    let subInsuranceDetailsItemCollectionViewCell = collectionView.dequeueCell(
                        SubInsuranceDetailsItemCollectionViewCell.self,
                        indexPath: indexPath
                    )
                    return subInsuranceDetailsItemCollectionViewCell
                }
        })
        
        return dataSource
    }

    // TODO: Update
    private func makeDetailLayout() -> UICollectionViewLayout {
        let sections = [makeSubInsuranceTitleSection(), makeSubInsuranceDetailsSection()]

        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) in
            return sections[sectionIndex]
        }
        return layout
    }

    private func makeSubInsuranceTitleHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(260))
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return headerElement
    }

    private func makeSubInsuranceDetailsHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(260))
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return headerElement
    }

    private func makeSubInsuranceTitleSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let cardSection = NSCollectionLayoutSection(group: group)
        cardSection.boundarySupplementaryItems = [makeSubInsuranceTitleHeader()]
        return cardSection
    }

    private func makeSubInsuranceDetailsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let cardSection = NSCollectionLayoutSection(group: group)
        cardSection.boundarySupplementaryItems = [makeSubInsuranceDetailsHeader()]
        return cardSection
    }
}

extension HomeSubInsuranceDetailViewController: UICollectionViewDelegate {

}
