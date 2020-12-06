//
//  GapListViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2020-06-12.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class GapListViewController: UIViewController {
    enum Section: CaseIterable {
        case gap
    }

    typealias DataSource = UICollectionViewDiffableDataSource<Section, GapSuggestion>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, GapSuggestion>

    private lazy var dataSource = makeDataSource()

    // MARK: - Public variables
    lazy var collectionView: UICollectionView = {
        let insuranceSuggestionsLayout = makeInsuranceSuggestionsLayout()
        return UICollectionView(frame: .zero, collectionViewLayout: insuranceSuggestionsLayout)
    }()

    // MARK: - Private variables
    private let storeController: StoreController
    private let iconView = UIImageView()
    private let titleLabel = HolkLabel()
    private let numberLabel = HolkLabel()
    private let separatorLine = UIView()
    private let gaps: [GapSuggestion]

    init(storeController: StoreController) {
        self.storeController = storeController
        self.gaps = storeController.suggestionStore.gaps

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

        navigationController?.navigationBar.backgroundColor = .clear
    }

    private func setup() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.setAppearance()

        view.backgroundColor = Color.mainBackground

        iconView.tintColor = Color.mainForeground
        iconView.image = UIImage.gap
        iconView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.text = LocalizedString.Suggestion.Gap.gaps
        titleLabel.styleGuide = .header4
        titleLabel.textColor = Color.mainForeground
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        if gaps.count == 1 {
            numberLabel.text = String(format: LocalizedString.Generic.piece, "\(gaps.count)")
        } else {
            numberLabel.text = String(format: LocalizedString.Generic.pieces, "\(gaps.count)")
        }

        numberLabel.styleGuide = .number3
        numberLabel.textColor = Color.mainForeground
        numberLabel.textAlignment = .right
        numberLabel.translatesAutoresizingMaskIntoConstraints = false

        separatorLine.backgroundColor = Color.separator
        separatorLine.translatesAutoresizingMaskIntoConstraints = false

        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.registerCell(GapCollectionViewCell.self)
        collectionView.registerReusableSupplementaryView(SuggestionCollectionHeaderView.self, of: UICollectionView.elementKindSectionHeader)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        setupLayout()
    }

    private func setupLayout() {
        view.addSubview(iconView)
        view.addSubview(titleLabel)
        view.addSubview(numberLabel)
        view.addSubview(separatorLine)
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            iconView.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            iconView.widthAnchor.constraint(equalTo: iconView.heightAnchor),
            iconView.heightAnchor.constraint(equalToConstant: 32),

            titleLabel.leadingAnchor.constraint(equalTo: iconView.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: numberLabel.leadingAnchor, constant: 4),

            numberLabel.lastBaselineAnchor.constraint(equalTo: titleLabel.lastBaselineAnchor),
            numberLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            separatorLine.topAnchor.constraint(equalTo: titleLabel.lastBaselineAnchor, constant: 16),
            separatorLine.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separatorLine.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 1),

            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: separatorLine.bottomAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension GapListViewController {
    private func makeInsuranceSuggestionsLayout() -> UICollectionViewLayout {
        let sections = [makeInsuranceSuggestionSection()]

        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) in
            return sections[sectionIndex]
        }
        return layout
    }

    private func makeInsuranceSuggestionSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(500))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(230))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let thinkOfsSection = NSCollectionLayoutSection(group: group)
        thinkOfsSection.boundarySupplementaryItems = [UICollectionViewCompositionalLayout.makeSectionHeaderElement()]
        thinkOfsSection.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
        thinkOfsSection.interGroupSpacing = 24
        return thinkOfsSection
    }

    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, gap) in
                let gapCollectionViewCell =  collectionView.dequeueCell(GapCollectionViewCell.self, indexPath: indexPath)
                gapCollectionViewCell.configure(gap)
                return gapCollectionViewCell
        })
        dataSource.supplementaryViewProvider = ({ (collectionView, kind, indexPath) in
            if kind == UICollectionView.elementKindSectionHeader {
                let suggestionCollectionHeaderView =
                    collectionView.dequeueReusableSupplementaryView(SuggestionCollectionHeaderView.self, of: kind, indexPath: indexPath)
                suggestionCollectionHeaderView.configure(LocalizedString.Suggestion.Gap.title)
                return suggestionCollectionHeaderView
            } else {
                return nil
            }
        })
        return dataSource
    }

    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(gaps)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

extension GapListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let gap = gaps[indexPath.item]
        let gapDetailsViewController = GapDetailsViewController(gap: gap)
        show(gapDetailsViewController, sender: self)
    }
}
