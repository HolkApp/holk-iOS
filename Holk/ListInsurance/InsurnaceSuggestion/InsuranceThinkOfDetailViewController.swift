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
        case insurance
        case subinsurance
    }

    enum SectionModel: Hashable {
        case paragraph(ThinkOfSuggestionParagraphViewModel)
        case insurance(ThinkOfInsuranceViewModel)
        case subinsurance(ThinkOfSubInsuranceViewModel)
    }

    typealias DataSource = UICollectionViewDiffableDataSource<Section, SectionModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, SectionModel>

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
                    return nil
                case .insurance(let thinkOfInsuranceViewModel):
                    return nil
                case .subinsurance(let thinkOfSubInsuranceViewModel):
                    return nil
                }
        })
//        dataSource.supplementaryViewProvider = ({ [weak self] (collectionView, kind, indexPath) in
//            guard let self = self else { return nil }
//            if kind == UICollectionView.elementKindSectionHeader {
//                let subInsuranceHeaderView = collectionView.dequeueHeaderFooterView(
//                        type: SubInsuranceHeaderView.self,
//                        of: kind, indexPath: indexPath
//                )
//                subInsuranceHeaderView.configure(self.insurance)
//                subInsuranceHeaderView.subInsurancesViewController = self
//                return subInsuranceHeaderView
//            } else {
//                return nil
//            }
//        })
        return dataSource
    }
//
//    private func applySnapshot(animatingDifferences: Bool = true) {
//        var snapshot = Snapshot()
//        let sections = Section.allCases
//        snapshot.appendSections(sections)
//        switch selectedSegment {
//        case .basic:
//            snapshot.appendItems(basicSubInsurance)
//        case .additional:
//            snapshot.appendItems(additionalSubInsurance)
//        }
//
//        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
//    }
//
    private func makeThinkOfSuggestionLayout() -> UICollectionViewLayout {
//        let sections = [makeSumodelCardsSection()]

        let sections = [NSCollectionLayoutSection]()
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) in
            return sections[sectionIndex]
        }
        return layout
    }
//
//    private func makeSubInsuranceSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
//        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(260))
//        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
//        return headerElement
//    }
//
//    private func makeSumodelCardsSection() -> NSCollectionLayoutSection {
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
//        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
//        let cardSection = NSCollectionLayoutSection(group: group)
//        cardSection.interGroupSpacing = 24
//        cardSection.contentInsets = .init(top: 40, leading: 0, bottom: 20, trailing: 0)
//        cardSection.boundarySupplementaryItems = [makeSubInsuranceSectionHeader()]
//        return cardSection
//    }
}
