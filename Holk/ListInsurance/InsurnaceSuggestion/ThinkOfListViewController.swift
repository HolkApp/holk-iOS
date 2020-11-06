//
//  ThinkOfListViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2020-06-12.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class ThinkOfListViewController: UIViewController {
    enum Section: CaseIterable {
        case thinkOf
    }

    typealias DataSource = UICollectionViewDiffableDataSource<Section, ThinkOfSuggestion>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ThinkOfSuggestion>

    private lazy var dataSource = makeDataSource()

    // MARK: - Public variables
    lazy var collectionView: UICollectionView = {
        let insurancSuggestionsLayout = UICollectionViewCompositionalLayout.makeInsuranceSuggestionsLayout()
        return UICollectionView(frame: .zero, collectionViewLayout: insurancSuggestionsLayout)
    }()

    // MARK: - Private variables
    private let storeController: StoreController
    private let iconView = UIImageView()
    private let titleLabel = HolkLabel()
    private let numberLabel = HolkLabel()
    private let separatorLine = UIView()
    private let thinkOfs: [ThinkOfSuggestion]

    init(storeController: StoreController) {
        self.storeController = storeController
        self.thinkOfs = storeController.suggestionStore.thinkOfs

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
        navigationItem.setAppearance()

        view.backgroundColor = Color.mainBackground

        iconView.tintColor = Color.mainForeground
        iconView.image = UIImage.thinkOf
        iconView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.styleGuide = .header4
        titleLabel.text = LocalizedString.Suggestion.ThinkOf.thinkOfs
        titleLabel.textColor = Color.mainForeground
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        numberLabel.styleGuide = .number3
        if thinkOfs.count == 1 {
            numberLabel.text = String(format: LocalizedString.Generic.piece, "\(thinkOfs.count)")
        } else {
            numberLabel.text = String(format: LocalizedString.Generic.pieces, "\(thinkOfs.count)")
        }
        numberLabel.textColor = Color.mainForeground
        numberLabel.textAlignment = .right
        numberLabel.translatesAutoresizingMaskIntoConstraints = false

        separatorLine.backgroundColor = Color.separator
        separatorLine.translatesAutoresizingMaskIntoConstraints = false

        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.registerCell(ThinkOfCollectionViewCell.self)
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

extension ThinkOfListViewController {
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, thinkOf) in
                let thinkOfCollectionViewCell =  collectionView.dequeueCell(ThinkOfCollectionViewCell.self, indexPath: indexPath)
                thinkOfCollectionViewCell.configure(thinkOf)
                return thinkOfCollectionViewCell
        })
        dataSource.supplementaryViewProvider = ({ (collectionView, kind, indexPath) in
            if kind == UICollectionView.elementKindSectionHeader {
                let suggestionCollectionHeaderView =
                    collectionView.dequeueReusableSupplementaryView(SuggestionCollectionHeaderView.self, of: kind, indexPath: indexPath)
                suggestionCollectionHeaderView.configure(LocalizedString.Suggestion.ThinkOf.title)
                return suggestionCollectionHeaderView
            } else {
                return nil
            }
        })
        return dataSource
    }

    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(thinkOfs)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

extension ThinkOfListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let thinkOf = thinkOfs[indexPath.item]
        let thinkOfDetailsViewController = ThinkOfDetailsViewController(storeController: storeController, thinkOf: thinkOf)
        show(thinkOfDetailsViewController, sender: self)
    }
}
