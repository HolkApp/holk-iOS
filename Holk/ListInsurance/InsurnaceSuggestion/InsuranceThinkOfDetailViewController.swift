//
//  InsuranceThinkOfDetailViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2020-07-08.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class InsuranceThinkOfDetailViewController: UIViewController {

    enum Section: CaseIterable {
        case banner
        case paragraph
        case subInsurance
    }

    enum Item: Hashable {
        case banner(ThinkOfSuggestionBannerViewModel)
        case paragraph(ThinkOfSuggestionParagraphViewModel)
        case subInsurance(ThinkOfSubInsuranceViewModel)
    }

    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

    private let viewModel: InsuranceThinkOfDetailViewModel
    private var storeController: StoreController
    private var thinkOf: ThinkOfSuggestion
    private var relatedInsurances: [Insurance]

    private lazy var dataSource = makeDataSource()
    private lazy var collectionView: UICollectionView = {
        let layout = makeThinkOfSuggestionLayout()
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()

    init(storeController: StoreController, thinkOf: ThinkOfSuggestion) {
        self.storeController = storeController
        self.thinkOf = thinkOf
        relatedInsurances = storeController.insuranceStore.relatedInsurances(thinkOf: thinkOf)
        viewModel = InsuranceThinkOfDetailViewModel(storeController, thinkOfSuggestion: thinkOf, insurances: relatedInsurances)

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
        navigationItem.setAppearance(backgroundColor: viewModel.headerBackgroundViewColor ?? Color.secondaryBackground)
        navigationController?.navigationBar.tintColor = Color.secondaryBackground

        collectionView.bounces = false
        collectionView.backgroundColor = Color.secondaryBackground
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.registerCell(ThinkOfBannerCollectionViewCell.self)
        collectionView.registerReusableSupplementaryView(ThinkOfBannerCollectionHeaderView.self, of: UICollectionView.elementKindSectionHeader)
        collectionView.registerCell(ThinkOfParagraphCollectionViewCell.self)
        collectionView.registerCell(SubInsuranceCollectionViewCell.self)
        collectionView.registerReusableSupplementaryView(ThinkOfRelatedInsuranceCollectionHeaderView.self, of: UICollectionView.elementKindSectionHeader)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        applySnapshot(animatingDifferences: false)
    }
}

// MARK: UICollectionViewLayout
extension InsuranceThinkOfDetailViewController {
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, section) in
                switch section {
                case .banner(let thinkOfSuggestionBannerViewModel):
                    let thinkOfBannerCollectionViewCell = collectionView.dequeueCell(ThinkOfBannerCollectionViewCell.self, indexPath: indexPath)
                    thinkOfBannerCollectionViewCell.configure(thinkOfSuggestionBannerViewModel)
                    return thinkOfBannerCollectionViewCell
                case .paragraph(let thinkOfSuggestionParagraphViewModel):
                    let thinkOfParagraphCollectionViewCell = collectionView.dequeueCell(ThinkOfParagraphCollectionViewCell.self, indexPath: indexPath)
                    thinkOfParagraphCollectionViewCell.configure(thinkOfSuggestionParagraphViewModel)
                    return thinkOfParagraphCollectionViewCell
                case .subInsurance(let thinkOfSubInsuranceViewModel):
                    let subInsuranceCollectionViewCell = collectionView.dequeueCell(SubInsuranceCollectionViewCell.self, indexPath: indexPath)
                    subInsuranceCollectionViewCell.configure(thinkOfSubInsuranceViewModel.subInsurance)
                    return subInsuranceCollectionViewCell
                }
        })
        dataSource.supplementaryViewProvider = ({ [weak self] (collectionView, kind, indexPath) in
            guard let self = self else { return nil }
            switch Section.allCases[indexPath.section] {
            case.banner:
                if kind == UICollectionView.elementKindSectionHeader {
                    let thinkOfDetailCollectionHeaderView = collectionView.dequeueReusableSupplementaryView(
                        ThinkOfBannerCollectionHeaderView.self,
                        of: kind,
                        indexPath: indexPath
                    )
                    thinkOfDetailCollectionHeaderView.configure(self.viewModel)
                    return thinkOfDetailCollectionHeaderView
                }
                return nil
            case .paragraph:
                return nil
            case .subInsurance:
                if kind == UICollectionView.elementKindSectionHeader, let insurnaceViewModel = self.viewModel.makeThinkOfInsuranceViewModel() {
                    let thinkOfRelatedInsuranceCollectionHeaderView = collectionView.dequeueReusableSupplementaryView(
                        ThinkOfRelatedInsuranceCollectionHeaderView.self,
                        of: kind,
                        indexPath: indexPath
                    )
                    thinkOfRelatedInsuranceCollectionHeaderView.configure(insurnaceViewModel)
                    return thinkOfRelatedInsuranceCollectionHeaderView
                }
                return nil
            }
        })
        return dataSource
    }

    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        let sections = Section.allCases
        snapshot.appendSections(sections)
        sections.forEach { section in
            switch section {
            case .banner:
                let bannerItem = Item.banner(viewModel.makeThinkOfSuggestionBannerViewModel())
                snapshot.appendItems([bannerItem], toSection: section)
            case .paragraph:
                let paragraphItems = viewModel.makeAllThinkOfSuggestionParagraphViewModel().map({ Item.paragraph($0) })
                snapshot.appendItems(paragraphItems, toSection: section)
            case .subInsurance:
                let subInsuranceItems = viewModel.makeAllThinkOfSubInsuranceViewModel().map { Item.subInsurance($0) }
                snapshot.appendItems(subInsuranceItems, toSection: section)
            }
        }

        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

    private func makeThinkOfSuggestionLayout() -> UICollectionViewLayout {
        let sections = [makeBannerSection(), makeParagraphSection(), makeSubInsuranceCardsSection()]

        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) in
            return sections[sectionIndex]
        }
        return layout
    }

    private func makeBannerSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(390))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(390))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let cardSection = NSCollectionLayoutSection(group: group)
        cardSection.contentInsets = .init(top: 0, leading: 0, bottom: 36, trailing: 0)
        cardSection.boundarySupplementaryItems = [makeThinkOfDetailHeader()]
        return cardSection
    }

    private func makeThinkOfDetailHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(240))
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return headerElement
    }

    private func makeParagraphSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(60))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(60))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let cardSection = NSCollectionLayoutSection(group: group)
        cardSection.interGroupSpacing = 24
        cardSection.contentInsets = .init(top: 0, leading: 0, bottom: 20, trailing: 0)
        return cardSection
    }

    private func makeSubInsuranceCardsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
        let cardSection = NSCollectionLayoutSection(group: group)
        cardSection.interGroupSpacing = 24
        cardSection.contentInsets = .init(top: 20, leading: 0, bottom: 20, trailing: 0)
        cardSection.boundarySupplementaryItems = [makeSubInsuranceSectionHeader()]
        return cardSection
    }

    private func makeSubInsuranceSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(240))
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return headerElement
    }
}
