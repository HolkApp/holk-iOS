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
        case paragraph
        case subInsurance
    }

    enum Item: Hashable {
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
        viewModel = InsuranceThinkOfDetailViewModel(thinkOfSuggestion: thinkOf, insurances: relatedInsurances)

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
        navigationItem.setAppearance(backgroundColor: Color.secondaryBackground)
        
        collectionView.backgroundColor = Color.secondaryBackground
        collectionView.showsVerticalScrollIndicator = false
        collectionView.registerCell(ThinkOfParagraphCollectionViewCell.self)
        collectionView.registerReusableSupplementaryView(ThinkOfRelatedInsuranceCollectionHeaderView.self, of: UICollectionView.elementKindSectionHeader)
        collectionView.registerCell(SubInsuranceCollectionViewCell.self)
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
            case .paragraph:
                return nil
            case .subInsurance:
                if kind == UICollectionView.elementKindSectionHeader {
                    if let insurnaceViewModel = self.viewModel.makeThinkOfInsuranceViewModel() {
                        let thinkOfRelatedInsuranceCollectionHeaderView = collectionView.dequeueReusableSupplementaryView(
                                ThinkOfRelatedInsuranceCollectionHeaderView.self,
                                of: kind,
                                indexPath: indexPath
                        )
                        thinkOfRelatedInsuranceCollectionHeaderView.configure(insurnaceViewModel)
                        return thinkOfRelatedInsuranceCollectionHeaderView
                    }
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
        let sections = [makeParagraphSection(), makeSubInsuranceCardsSection()]

        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) in
            return sections[sectionIndex]
        }
        return layout
    }

    private func makeParagraphSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(60))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(60))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let cardSection = NSCollectionLayoutSection(group: group)
        cardSection.interGroupSpacing = 24
        cardSection.contentInsets = .init(top: 0, leading: 0, bottom: 20, trailing: 0)
//        cardSection.boundarySupplementaryItems = [makeSubInsuranceSectionHeader()]
        return cardSection
    }

    private func makeSubInsuranceSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(240))
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
        cardSection.contentInsets = .init(top: 20, leading: 0, bottom: 20, trailing: 0)
        cardSection.boundarySupplementaryItems = [makeSubInsuranceSectionHeader()]
        return cardSection
    }
}
