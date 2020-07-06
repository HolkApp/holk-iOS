//
//  HomeinsuranceSubmodelsViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2020-07-01.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class HomeinsuranceSubmodelsViewController: UIViewController {
    enum Section: CaseIterable {
        case submodel
    }

    enum HomeinsuranceSubmodelSegment: Hashable {
        case basic(Insurance.Segment)
        case additional(Insurance.Segment)
    }

    enum SubmodelSegment {
        case basic
        case additional
    }

    typealias DataSource = UICollectionViewDiffableDataSource<Section, HomeinsuranceSubmodelSegment>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, HomeinsuranceSubmodelSegment>

    // MARK: - Public Variables
    var storeController: StoreController

    // MARK: - Private Variables
    private let insurance: Insurance
    private let basicSubmodel: [HomeinsuranceSubmodelSegment]
    private let additionalSubmodel: [HomeinsuranceSubmodelSegment]
    private var selectedSegment: SubmodelSegment = .basic
    private lazy var dataSource = makeDataSource()
    private lazy var collectionView: UICollectionView = {
        let layout = makeSubinsurancesLayout()
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()

    // MARK: - Init
    init(storeController: StoreController, insurance: Insurance) {
        self.storeController = storeController
        self.insurance = insurance
        basicSubmodel = insurance.segments.compactMap { HomeinsuranceSubmodelSegment.basic($0) }
        // TODO: Update this
        additionalSubmodel = []

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        applySnapshot()
    }

    func updateSelection(_ segment: SubmodelSegment) {
        selectedSegment = segment
        applySnapshot()
    }

    private func setup() {
        collectionView.backgroundColor = Color.secondaryBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(SubmodelCollectionViewCell.self, forCellWithReuseIdentifier: SubmodelCollectionViewCell.identifier)
        collectionView.register(SubmodelHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SubmodelHeaderView.identifier)
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: UICollectionViewLayout
extension HomeinsuranceSubmodelsViewController {
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, segment) in
                switch segment {
                case .basic(let basicSegment):
                    let submodelCollectionViewCell = collectionView.dequeueCell(ofType: SubmodelCollectionViewCell.self, indexPath: indexPath)
                    submodelCollectionViewCell.configure(basicSegment)
                    return submodelCollectionViewCell
                case .additional(let additionalSegment):
                    let submodelCollectionViewCell = collectionView.dequeueCell(ofType: SubmodelCollectionViewCell.self, indexPath: indexPath)
                    submodelCollectionViewCell.configure(additionalSegment)
                    return submodelCollectionViewCell
                }
        })
        dataSource.supplementaryViewProvider = ({ [weak self] (collectionView, kind, indexPath) in
            guard let self = self else { return nil }
            if kind == UICollectionView.elementKindSectionHeader {
                let submodelHeaderView = collectionView.dequeueHeaderFooterView(
                        type: SubmodelHeaderView.self,
                        of: kind, indexPath: indexPath
                )
                submodelHeaderView.configure(self.insurance)
                submodelHeaderView.submodelsViewController = self
                return submodelHeaderView
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
            snapshot.appendItems(basicSubmodel)
        case .additional:
            snapshot.appendItems(additionalSubmodel)
        }

        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

    private func makeSubinsurancesLayout() -> UICollectionViewLayout {
        let sections = [makeSumodelCardsSection()]

        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) in
            return sections[sectionIndex]
        }
        return layout
    }

    private func makeSubmodelSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(260))
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return headerElement
    }

    private func makeSumodelCardsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let cardSection = NSCollectionLayoutSection(group: group)
        cardSection.interGroupSpacing = 24
        cardSection.contentInsets = .init(top: 40, leading: 0, bottom: 20, trailing: 0)
        cardSection.boundarySupplementaryItems = [makeSubmodelSectionHeader()]
        return cardSection
    }
}
