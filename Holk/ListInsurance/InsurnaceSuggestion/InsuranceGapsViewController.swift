//
//  InsuranceGapsSuggestionViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2020-06-12.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class InsuranceGapsViewController: UIViewController {
    enum Section {
      case gap
    }

    typealias DataSource = UICollectionViewDiffableDataSource<Section, GapSuggestion>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, GapSuggestion>

    private lazy var dataSource = makeDataSource()

    // MARK: - Public variables
    lazy var collectionView: UICollectionView = {
        let insurancSuggestionsLayout = UICollectionViewCompositionalLayout.makeInsuranceSuggestionsLayout()
        return UICollectionView(frame: .zero, collectionViewLayout: insurancSuggestionsLayout)
    }()

    // MARK: - Private variables
    private let storeController: StoreController
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let numberLabel = UILabel()
    private let separatorLine = UIView()
    private let gaps: [GapSuggestion]

    init(storeController: StoreController) {
        self.storeController = storeController
        self.gaps = storeController.suggestionStore.suggestions.value?.gaps ?? []

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear

        view.backgroundColor = Color.mainBackground

        iconView.tintColor = Color.mainForeground
        iconView.image = UIImage(systemName: "bell")?.withSymbolWeightConfiguration(.light)
        iconView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.setStyleGuide(.header4)
        titleLabel.text = "Luckor"
        titleLabel.textColor = Color.mainForeground
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        numberLabel.setStyleGuide(.numbers3)
        numberLabel.text = "\(gaps.count) st"
        numberLabel.textColor = Color.mainForeground
        numberLabel.textAlignment = .right
        numberLabel.translatesAutoresizingMaskIntoConstraints = false

        separatorLine.backgroundColor = Color.placeHolder
        separatorLine.translatesAutoresizingMaskIntoConstraints = false

        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.register(InsuranceGapsCollectionViewCell.self, forCellWithReuseIdentifier: InsuranceGapsCollectionViewCell.identifier)
        collectionView.register(InsuranceSuggestionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: InsuranceSuggestionHeaderView.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        setupLayout()
        applySnapshot(animatingDifferences: false)
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

extension InsuranceGapsViewController {
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, gap) in
                let insuranceGapsSuggestionCollectionViewCell =  collectionView.dequeueCell(ofType: InsuranceGapsCollectionViewCell.self, indexPath: indexPath)
                insuranceGapsSuggestionCollectionViewCell.configure(gap)
                return insuranceGapsSuggestionCollectionViewCell
        })
        dataSource.supplementaryViewProvider = ({ (collectionView, kind, indexPath) in
            if kind == UICollectionView.elementKindSectionHeader {
                let insuranceSuggestionHeaderView =
                    collectionView.dequeueHeaderFooterView(type: InsuranceSuggestionHeaderView.self, of: kind, indexPath: indexPath)
                insuranceSuggestionHeaderView.configure("Luckor som finns i ditt skydd")
                return insuranceSuggestionHeaderView
            } else {
                return nil
            }
        })
        return dataSource
    }

    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.gap])
        snapshot.appendItems(gaps)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

extension InsuranceGapsViewController: UICollectionViewDelegate {}
