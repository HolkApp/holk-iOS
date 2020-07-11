//
//  InsuranceThinkOfsViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2020-06-12.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class InsuranceThinkOfsViewController: UIViewController {
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
    private let titleLabel = UILabel()
    private let numberLabel = UILabel()
    private let separatorLine = UIView()
    private let thinkOfs: [ThinkOfSuggestion]

    init(storeController: StoreController) {
        self.storeController = storeController
        self.thinkOfs = storeController.suggestionStore.suggestions.value?.thinkOfs ?? []

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
        iconView.image = UIImage(named: "light")?.withSymbolWeightConfiguration(.light)
        iconView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.setStyleGuide(.header4)
        titleLabel.text = "Tänk på"
        titleLabel.textColor = Color.mainForeground
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        numberLabel.setStyleGuide(.number3)
        numberLabel.text = "\(thinkOfs.count) st"
        numberLabel.textColor = Color.mainForeground
        numberLabel.textAlignment = .right
        numberLabel.translatesAutoresizingMaskIntoConstraints = false

        separatorLine.backgroundColor = Color.placeholder
        separatorLine.translatesAutoresizingMaskIntoConstraints = false

        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.register(InsuranceThinkOfsCollectionViewCell.self, forCellWithReuseIdentifier: InsuranceThinkOfsCollectionViewCell.identifier)
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

extension InsuranceThinkOfsViewController {
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, thinkOf) in
                let insuranceThinkOfsCollectionViewCell =  collectionView.dequeueCell(ofType: InsuranceThinkOfsCollectionViewCell.self, indexPath: indexPath)
                insuranceThinkOfsCollectionViewCell.configure(thinkOf)
                return insuranceThinkOfsCollectionViewCell
        })
        dataSource.supplementaryViewProvider = ({ (collectionView, kind, indexPath) in
            if kind == UICollectionView.elementKindSectionHeader {
                let insuranceSuggestionHeaderView =
                    collectionView.dequeueHeaderFooterView(type: InsuranceSuggestionHeaderView.self, of: kind, indexPath: indexPath)
                insuranceSuggestionHeaderView.configure("Viktiga saker att tänka på")
                return insuranceSuggestionHeaderView
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

extension InsuranceThinkOfsViewController: UICollectionViewDelegate {
}
