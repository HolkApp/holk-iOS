//
//  HomeSubInsuranceDetailViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2020-10-11.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class HomeSubInsuranceDetailViewController: UIViewController {
    enum Section: CaseIterable {
        case title
        case detailsSegment
        case detailsItem
    }

    enum SubInsuranceDetailsItem: Hashable {
        case title
        case segment([Insurance.SubInsurance.Item.Segment])
        case cover(Insurance.SubInsurance.Item)
        case gap
        case thinkOf
    }

    // MARK: - Private Variables
    private var storeController: StoreController
    private var subInsurance: Insurance.SubInsurance
    private var selectedSubInsuranceDetails: SubInsuranceDetailViewModel.SelectedSubInsuranceDetails = .cover {
        didSet {
            DispatchQueue.main.async {
                self.applySnapshot()
            }
        }
    }
    private var selectedSubInsuranceCoverSegment: Insurance.SubInsurance.Item.Segment? {
        didSet {
            DispatchQueue.main.async {
                self.applySnapshot()
            }
        }
    }
    private var subInsuranceDetailViewModel: SubInsuranceDetailViewModel
    private lazy var dataSource = makeDataSource()

    typealias DataSource = UICollectionViewDiffableDataSource<Section, SubInsuranceDetailsItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, SubInsuranceDetailsItem>

    private lazy var collectionView: UICollectionView = {
        let layout = makeDetailLayout()
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()

    init(storeController: StoreController, subInsurance: Insurance.SubInsurance) {
        self.storeController = storeController
        self.subInsurance = subInsurance
        subInsuranceDetailViewModel = SubInsuranceDetailViewModel(storeController: storeController, subInsurance: subInsurance)

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationItem.setAppearance()
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
        collectionView.registerCell(SubInsuranceDetailsSegmentCollectionViewCell.self)
        collectionView.registerCell(SubInsuranceDetailsItemCollectionViewCell.self)
        collectionView.registerCell(ThinkOfCollectionViewCell.self)
        collectionView.registerReusableSupplementaryView(SubInsuranceDetailsHeaderView.self, of: UICollectionView.elementKindSectionHeader)

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
            switch section {
            case .title:
                snapshot.appendItems([.title], toSection: section)
            case .detailsSegment:
                if subInsuranceDetailViewModel.groupedItems.keys.count > 1, case .cover = selectedSubInsuranceDetails {
                    let segments = subInsuranceDetailViewModel.groupedItems.map(\.key).sorted()
                    snapshot.appendItems([.segment(segments)], toSection: section)
                }
            case .detailsItem:
                switch selectedSubInsuranceDetails {
                case .cover:
                    // TODO: Check the segment and add different snapshot
                    switch selectedSubInsuranceCoverSegment {
                    case .home:
                        subInsurance.items.forEach { snapshot.appendItems([.cover($0)], toSection: section) }
                    case .outdoor:
                        snapshot.appendItems([], toSection: section)
                    default:
                        subInsurance.items.forEach { snapshot.appendItems([.cover($0)], toSection: section) }
                    }
                case .gaps:
                    snapshot.appendItems([], toSection: section)
                case .thinkOfs:
                    self.subInsuranceDetailViewModel.thinkOfs.forEach { _ in
                        snapshot.appendItems([.thinkOf], toSection: section)
                    }
                }
            }
        }
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

    private func makeDataSource() -> DataSource {
        // TODO:
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { [weak self] (collectionView, indexPath, subInsuranceDetailsItem) in
                guard let self = self else { return UICollectionViewCell() }
                switch subInsuranceDetailsItem {
                case .title:
                    let subInsuranceDetailsTitleCollectionViewCell = collectionView.dequeueCell(
                        SubInsuranceDetailsTitleCollectionViewCell.self,
                        indexPath: indexPath
                    )
                    subInsuranceDetailsTitleCollectionViewCell.configure(self.selectedSubInsuranceDetails)
                    return subInsuranceDetailsTitleCollectionViewCell
                case .segment(let segments):
                    let subInsuranceDetailsSegmentCollectionViewCell = collectionView.dequeueCell(
                        SubInsuranceDetailsSegmentCollectionViewCell.self,
                        indexPath: indexPath
                    )
                    subInsuranceDetailsSegmentCollectionViewCell.configure(self.subInsurance, segments: segments)
                    subInsuranceDetailsSegmentCollectionViewCell.delegate = self
                    return subInsuranceDetailsSegmentCollectionViewCell
                case .cover(let item):
                    let subInsuranceDetailsItemCollectionViewCell = collectionView.dequeueCell(
                        SubInsuranceDetailsItemCollectionViewCell.self,
                        indexPath: indexPath
                    )
                    subInsuranceDetailsItemCollectionViewCell.configure(item)
                    return subInsuranceDetailsItemCollectionViewCell
                case .gap:
                    let subInsuranceDetailsItemCollectionViewCell = collectionView.dequeueCell(
                        SubInsuranceDetailsItemCollectionViewCell.self,
                        indexPath: indexPath
                    )
                    return subInsuranceDetailsItemCollectionViewCell
                case .thinkOf:
                    let thinkOfCollectionViewCell = collectionView.dequeueCell(
                        ThinkOfCollectionViewCell.self,
                        indexPath: indexPath
                    )
                    thinkOfCollectionViewCell.configure(self.subInsuranceDetailViewModel.thinkOfs[indexPath.item])
                    return thinkOfCollectionViewCell
                }
        })
        dataSource.supplementaryViewProvider = ({ [weak self] (collectionView, kind, indexPath) in
            guard let self = self, kind == UICollectionView.elementKindSectionHeader else { return nil }
            if Section.allCases[indexPath.section] == .title {
                let subInsuranceDetailsHeaderView = collectionView.dequeueReusableSupplementaryView(
                    SubInsuranceDetailsHeaderView.self,
                    of: kind,
                    indexPath: indexPath
                )
                subInsuranceDetailsHeaderView.configure(subInsurance: self.subInsurance)
                subInsuranceDetailsHeaderView.delegate = self
                return subInsuranceDetailsHeaderView
            } else {
                return nil
            }
        })
        return dataSource
    }

    // TODO: Update
    private func makeDetailLayout() -> UICollectionViewLayout {
        let sections = [makeSubInsuranceTitleSection(), makeSubInsuranceDetailsSegment(), makeSubInsuranceDetailsSection()]

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

    private func makeSubInsuranceTitleSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let cardSection = NSCollectionLayoutSection(group: group)
        cardSection.boundarySupplementaryItems = [makeSubInsuranceTitleHeader()]
        return cardSection
    }

    private func makeSubInsuranceDetailsSegment() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let cardSection = NSCollectionLayoutSection(group: group)
        return cardSection
    }

    private func makeSubInsuranceDetailsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let cardSection = NSCollectionLayoutSection(group: group)
        cardSection.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
        cardSection.interGroupSpacing = 24
        return cardSection
    }
}

// MARK: SubInsuranceDetailsHeaderViewDelegate
extension HomeSubInsuranceDetailViewController: SubInsuranceDetailsHeaderViewDelegate {
    func subInsuranceDetailsHeaderView(_ subInsuranceDetailsHeaderView: SubInsuranceDetailsHeaderView, updatedSelection: SubInsuranceDetailViewModel.SelectedSubInsuranceDetails) {
        selectedSubInsuranceDetails = updatedSelection
    }
}

// MARK: SubInsuranceDetailsSegmentHeaderViewDelegate
extension HomeSubInsuranceDetailViewController: SubInsuranceDetailsSegmentCollectionViewCellDelegate {
    func subInsuranceDetailsSegmentCollectionViewCell(_ headerView: SubInsuranceDetailsSegmentCollectionViewCell, updatedSegment: Insurance.SubInsurance.Item.Segment) {
        selectedSubInsuranceCoverSegment = updatedSegment
    }
}

// MARK: UICollectionViewDelegate
extension HomeSubInsuranceDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch selectedSubInsuranceDetails {
        case .cover:
            break
        case .gaps:
            break
        case .thinkOfs:
            let thinkOf = subInsuranceDetailViewModel.thinkOfs[indexPath.item]
            let thinkOfDetailsViewController = ThinkOfDetailsViewController(storeController: storeController, thinkOf: thinkOf)
            present(thinkOfDetailsViewController, animated: true)
        }
    }
}
