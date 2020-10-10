//
//  thinkOfDetailsViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2020-07-08.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class ThinkOfDetailsViewController: UIViewController {

    enum Section: CaseIterable {
        case banner
        case paragraph
        case subInsurance
    }

    enum Item: Hashable {
        case banner(imageURL: URL?)
        case paragraph(ThinkOfParagraphViewModel)
        case subInsurance(ThinkOfSubInsuranceViewModel)
    }

    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

    private let viewModel: ThinkOfDetailsViewModel
    private var storeController: StoreController
    private var thinkOf: ThinkOfSuggestion
    private var shouldShowSubInsurance: Bool

    private lazy var dataSource = makeDataSource()
    private lazy var collectionView: UICollectionView = {
        let layout = makeThinkOfSuggestionLayout()
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()

    init(storeController: StoreController, thinkOf: ThinkOfSuggestion, shouldShowSubInsurance: Bool = true) {
        self.storeController = storeController
        self.thinkOf = thinkOf
        self.shouldShowSubInsurance = shouldShowSubInsurance
        viewModel = ThinkOfDetailsViewModel(storeController, thinkOfSuggestion: thinkOf, insurances: storeController.insuranceStore.homeInsurances)

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
        navigationItem.setAppearance()
        navigationController?.navigationBar.tintColor = Color.secondaryBackground

        collectionView.delegate = self
        collectionView.bounces = false
        collectionView.backgroundColor = Color.secondaryBackground
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset.top = -(navigationController?.navigationBar.frame.height ?? 0)
        collectionView.contentInset.bottom = 40
        collectionView.registerCell(ThinkOfBannerCollectionViewCell.self)
        collectionView.registerCell(ThinkOfParagraphCollectionViewCell.self)
        collectionView.registerCell(SubInsuranceCollectionViewCell.self)
        collectionView.registerReusableSupplementaryView(
            ThinkOfBannerCollectionHeaderView.self,
            of: UICollectionView.elementKindSectionHeader
        )
        collectionView.registerReusableSupplementaryView(
            ThinkOfParagraphCollectionHeaderView.self,
            of: UICollectionView.elementKindSectionHeader
        )
        collectionView.registerReusableSupplementaryView(
            ThinkOfRelatedInsuranceCollectionHeaderView.self,
            of: UICollectionView.elementKindSectionHeader
        )
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
extension ThinkOfDetailsViewController {
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, section) in
                switch section {
                case .banner(let imageURL):
                    let thinkOfBannerCollectionViewCell = collectionView.dequeueCell(ThinkOfBannerCollectionViewCell.self, indexPath: indexPath)
                    thinkOfBannerCollectionViewCell.configure(imageURL)
                    return thinkOfBannerCollectionViewCell
                case .paragraph(let thinkOfSuggestionParagraphViewModel):
                    let thinkOfParagraphCollectionViewCell = collectionView.dequeueCell(ThinkOfParagraphCollectionViewCell.self, indexPath: indexPath)
                    thinkOfParagraphCollectionViewCell.configure(thinkOfSuggestionParagraphViewModel)
                    return thinkOfParagraphCollectionViewCell
                case .subInsurance(let thinkOfSubInsuranceViewModel):
                    let subInsuranceCollectionViewCell = collectionView.dequeueCell(SubInsuranceCollectionViewCell.self, indexPath: indexPath)
                    let thinkOfs = self.storeController.suggestionStore.thinkOfs(thinkOfSubInsuranceViewModel.subInsurance)
                    subInsuranceCollectionViewCell.configure(thinkOfSubInsuranceViewModel.subInsurance, thinkOfs: thinkOfs)
                    return subInsuranceCollectionViewCell
                }
        })
        dataSource.supplementaryViewProvider = ({ [weak self] (collectionView, kind, indexPath) in
            guard let self = self else { return nil }
            switch Section.allCases[indexPath.section] {
            case.banner:
                guard kind == UICollectionView.elementKindSectionHeader else {
                    return HolkEmptyCollectionHeaderView()
                }
                let thinkOfDetailCollectionHeaderView = collectionView.dequeueReusableSupplementaryView(
                    ThinkOfBannerCollectionHeaderView.self,
                    of: kind,
                    indexPath: indexPath
                )
                thinkOfDetailCollectionHeaderView.configure(self.viewModel)
                return thinkOfDetailCollectionHeaderView
            case .paragraph:
                guard kind == UICollectionView.elementKindSectionHeader else {
                    return HolkEmptyCollectionHeaderView()
                }
                let thinkOfParagraphCollectionHeaderView = collectionView.dequeueReusableSupplementaryView(
                    ThinkOfParagraphCollectionHeaderView.self,
                    of: kind,
                    indexPath: indexPath
                )
                let thinkOfParagraphHeaderViewModel = self.viewModel.makeThinkOfParagraphHeaderViewModel()
                thinkOfParagraphCollectionHeaderView.configure(thinkOfParagraphHeaderViewModel)
                return thinkOfParagraphCollectionHeaderView
            case .subInsurance:
                guard kind == UICollectionView.elementKindSectionHeader, let subInsuranceHeaderViewModel = self.viewModel.makeThinkOfSubInsuranceHeaderViewModel() else {
                    return HolkEmptyCollectionHeaderView()
                }
                let thinkOfRelatedInsuranceCollectionHeaderView = collectionView.dequeueReusableSupplementaryView(
                    ThinkOfRelatedInsuranceCollectionHeaderView.self,
                    of: kind,
                    indexPath: indexPath
                )
                thinkOfRelatedInsuranceCollectionHeaderView.configure(subInsuranceHeaderViewModel)
                return thinkOfRelatedInsuranceCollectionHeaderView
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
                let bannerItem = Item.banner(imageURL: viewModel.coverImage)
                snapshot.appendItems([bannerItem], toSection: section)
            case .paragraph:
                let paragraphItems = viewModel.makeAllThinkOfParagraphViewModel().map({ Item.paragraph($0) })
                snapshot.appendItems(paragraphItems, toSection: section)
            case .subInsurance:
                guard self.shouldShowSubInsurance else { return }
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
        cardSection.contentInsets = .init(top: -56, leading: 0, bottom: 36, trailing: 0)
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
        cardSection.contentInsets = .init(top: 45, leading: 0, bottom: 20, trailing: 0)
        cardSection.boundarySupplementaryItems = [makeParagraphSectionHeader()]
        return cardSection
    }

    private func makeParagraphSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
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
        cardSection.contentInsets = .init(top: 20, leading: 0, bottom: 0, trailing: 0)
        cardSection.boundarySupplementaryItems = [makeSubInsuranceSectionHeader()]
        return cardSection
    }

    private func makeSubInsuranceSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(240))
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return headerElement
    }
}

extension ThinkOfDetailsViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let alpha: CGFloat = max(min(scrollView.adjustedContentOffset.y, 60), 0) / 60
        navigationController?.navigationBar.backgroundColor = viewModel.headerBackgroundViewColor?.withAlphaComponent(alpha)
    }
}
