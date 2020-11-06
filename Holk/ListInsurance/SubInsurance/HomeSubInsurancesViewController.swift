//
//  HomeSubInsurancesViewController.swift
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
        case basic(Insurance.SubInsurance)
        case addon(Insurance.AddonInsurance)
    }

    enum SelectedSubInsuranceKind {
        case basic
        case addon
    }

    typealias DataSource = UICollectionViewDiffableDataSource<Section, HomeSubInsuranceSegment>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, HomeSubInsuranceSegment>

    // MARK: - Public Variables
    var storeController: StoreController

    // MARK: - Private Variables
    private let insurance: Insurance
    private let subInsurances: [HomeSubInsuranceSegment]
    private let addonInsurances: [HomeSubInsuranceSegment]
    private var selectedSubInsuranceKind: SelectedSubInsuranceKind = .basic
    private lazy var dataSource = makeDataSource()
    private lazy var collectionView: UICollectionView = {
        let layout = makeSubinsurancesLayout()
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()

    // MARK: - Init
    init(storeController: StoreController, insurance: Insurance) {
        self.storeController = storeController
        self.insurance = insurance
        subInsurances = insurance.subInsurances.compactMap { HomeSubInsuranceSegment.basic($0) }
        addonInsurances = insurance.addonInsurances.compactMap { HomeSubInsuranceSegment.addon($0) }

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
        collectionView.backgroundColor = Color.secondaryBackground
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
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
extension HomeSubInsurancesViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.adjustedContentOffset.y
        if let headerView = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(row: 0, section: 0)),
           yOffset <= 0 {
            headerView.transform = .init(translationX: 0, y: yOffset)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let homeSubInsuranceDetailViewController = HomeSubInsuranceDetailViewController(storeController: storeController, insurance: insurance, subInsurance: insurance.subInsurances[indexPath.item])
        show(homeSubInsuranceDetailViewController, sender: self)
    }

    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, subInsurance) in
                switch subInsurance {
                case .basic(let basicSubInsurance):
                    let subInsuranceCollectionViewCell = collectionView.dequeueCell(SubInsuranceCollectionViewCell.self, indexPath: indexPath)
                    let thinkOfs = self.storeController.suggestionStore.thinkOfs(basicSubInsurance)
                    subInsuranceCollectionViewCell.configure(basicSubInsurance, thinkOfs: thinkOfs)
                    return subInsuranceCollectionViewCell
                case .addon(let addonSubInsurance):
                    let subInsuranceCollectionViewCell = collectionView.dequeueCell(SubInsuranceCollectionViewCell.self, indexPath: indexPath)
                    // TODO: Fix this for add ons
                    subInsuranceCollectionViewCell.configure(addonSubInsurance, thinkOfs: [])
                    return subInsuranceCollectionViewCell
                }
        })
        dataSource.supplementaryViewProvider = ({ [weak self] (collectionView, kind, indexPath) in
            guard let self = self else { return nil }
            if kind == UICollectionView.elementKindSectionHeader {
                let subInsuranceHeaderView = collectionView.dequeueReusableSupplementaryView(
                    SubInsuranceHeaderView.self,
                    of: kind,
                    indexPath: indexPath
                )
                subInsuranceHeaderView.configure(self.insurance)
                subInsuranceHeaderView.delegate = self
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
        switch selectedSubInsuranceKind {
        case .basic:
            snapshot.appendItems(subInsurances)
        case .addon:
            snapshot.appendItems(addonInsurances)
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
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let cardSection = NSCollectionLayoutSection(group: group)
        cardSection.interGroupSpacing = 24
        cardSection.contentInsets = .init(top: 40, leading: 0, bottom: 0, trailing: 0)
        cardSection.boundarySupplementaryItems = [makeSubInsuranceSectionHeader()]
        return cardSection
    }
}

extension HomeSubInsurancesViewController: SubInsuranceHeaderViewDelegate {
    func updateSelection(_ subInsuranceHeaderView: SubInsuranceHeaderView, selectedSubInsuranceKind: SelectedSubInsuranceKind) {
        self.selectedSubInsuranceKind = selectedSubInsuranceKind
        applySnapshot()
    }
}
