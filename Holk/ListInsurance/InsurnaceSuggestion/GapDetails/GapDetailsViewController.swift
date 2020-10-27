//
//  GapDetailsViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2020-09-09.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class GapDetailsViewController: UIViewController {

    enum Section: CaseIterable {
        case banner
        case paragraph
    }

    enum Item: Hashable {
        case banner(GapBannerViewModel)
        case paragraph(GapParagraphViewModel)
    }

    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

    private let viewModel: GapDetailsViewModel
    private var gap: GapSuggestion

    private lazy var dataSource = makeDataSource()
    private lazy var collectionView: UICollectionView = {
        let layout = makeGapSuggestionLayout()
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    private let createButton = HolkButton()

    init(gap: GapSuggestion) {
        self.gap = gap

        self.viewModel = GapDetailsViewModel(gap)
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
        navigationController?.navigationBar.tintColor = Color.mainBackground

        collectionView.contentInset.top = -(navigationController?.navigationBar.frame.height ?? 0)
        collectionView.contentInset.bottom = 40
        collectionView.delegate = self
        collectionView.backgroundColor = Color.mainBackground
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.registerCell(GapBannerCollectionViewCell.self)
        collectionView.registerCell(GapParagraphCollectionViewCell.self)
        collectionView.registerReusableSupplementaryView(
            GapParagraphHeaderView.self,
            of: UICollectionView.elementKindSectionHeader
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        createButton.backgroundColor = Color.suggestionBackground
        createButton.layer.cornerRadius = 8
        createButton.styleGuide = .button1
        createButton.setTitle(LocalizedString.Suggestion.Gap.actionButton, for: .normal)
        createButton.set(color: Color.secondaryLabel)
        createButton.addTarget(self, action: #selector(createProtection), for: .touchUpInside)
        createButton.translatesAutoresizingMaskIntoConstraints = false

        createButton.layer.shadowRadius = 8
        createButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        createButton.layer.shadowColor = UIColor.black.withAlphaComponent(0.15).cgColor
        createButton.layer.shadowOpacity = 1

        view.addSubview(collectionView)
        view.addSubview(createButton)

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.heightAnchor.constraint(equalToConstant: 70),
            createButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])

        applySnapshot(animatingDifferences: false)
    }
}

// MARK: UICollectionViewLayout
extension GapDetailsViewController {
    @objc private func createProtection() {

    }

    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, section) in
                switch section {
                case .banner(let viewModel):
                    let gapBannerCollectionViewCell = collectionView.dequeueCell(GapBannerCollectionViewCell.self, indexPath: indexPath)
                    gapBannerCollectionViewCell.configure(viewModel)
                    return gapBannerCollectionViewCell
                case .paragraph(let viewModel):
                    let gapParagraphCollectionViewCell = collectionView.dequeueCell(GapParagraphCollectionViewCell.self, indexPath: indexPath)
                    gapParagraphCollectionViewCell.configure(viewModel)
                    return gapParagraphCollectionViewCell
                }
        })
        dataSource.supplementaryViewProvider = ({ [weak self] (collectionView, kind, indexPath) in
            guard let self = self else { return nil }
            switch Section.allCases[indexPath.section] {
            case.banner:
                return nil
            case .paragraph:
                if kind == UICollectionView.elementKindSectionHeader {
                    let gapParagraphHeaderViewModel = self.viewModel.makeGapParagraphHeaderViewModel()
                    let gapParagraphHeaderView = collectionView.dequeueReusableSupplementaryView(
                        GapParagraphHeaderView.self,
                        of: kind,
                        indexPath: indexPath
                    )
                    gapParagraphHeaderView.configure(gapParagraphHeaderViewModel)
                    return gapParagraphHeaderView
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
                let bannerItem = Item.banner(viewModel.makeGapBannerViewModel())
                snapshot.appendItems([bannerItem], toSection: section)
            case .paragraph:
                let paragraphItems = viewModel.makeAllGapParagraphViewModel().map { Item.paragraph($0) }
                snapshot.appendItems(paragraphItems, toSection: section)
            }
        }

        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

    private func makeGapSuggestionLayout() -> UICollectionViewLayout {
        let sections = [makeGapBannerSection(), makeGapParagraphSection()]

        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) in
            return sections[sectionIndex]
        }
        return layout
    }

    private func makeGapBannerSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(390))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(390))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let cardSection = NSCollectionLayoutSection(group: group)
        cardSection.contentInsets = .init(top: 0, leading: 0, bottom: 36, trailing: 0)
        return cardSection
    }

    private func makeGapParagraphSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(60))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(60))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let cardSection = NSCollectionLayoutSection(group: group)
        cardSection.interGroupSpacing = 24
        cardSection.boundarySupplementaryItems = [makeGapDetailHeader()]
        return cardSection
    }

    private func makeGapDetailHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(240))
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return headerElement
    }
}

extension GapDetailsViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.adjustedContentOffset.y
        let alpha: CGFloat = max(min(yOffset, 60), 0) / 60
        navigationController?.navigationBar.backgroundColor = viewModel.headerBackgroundViewColor?.withAlphaComponent(alpha)

        if let headerView = collectionView.cellForItem(at: IndexPath(row: 0, section: 0)),
           yOffset <= 0 {
            headerView.transform = .init(translationX: 0, y: yOffset)
        }
    }
}
