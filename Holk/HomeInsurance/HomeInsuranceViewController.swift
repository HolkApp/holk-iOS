//
//  HomeInsuranceViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2020-05-31.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class HomeInsuranceViewController: UIViewController {
    // MARK: - Public Variables
    weak var coordinator: InsuranceCoordinator?
    var selectedIndexPath: IndexPath?
    lazy var collectionView: UICollectionView = {
        let insuranceLayout = makeHomeInsuranceLayout()
        return UICollectionView(frame: .zero, collectionViewLayout: insuranceLayout)
    }()
    
    // MARK: - Private Variables
    private var storeController: StoreController
    private var insurance: Insurance

    init(storeController: StoreController, insurance: Insurance) {
        self.storeController = storeController
        self.insurance = insurance

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.barTintColor = Color.mainBackground
    }

    private func setup() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.setAppearance()
        
        view.backgroundColor = Color.mainBackground

        collectionView.contentInset.bottom = 40
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.registerCell(HomeInsuranceCollectionViewCell.self)
        collectionView.registerCell(HomeInsuranceBeneficiaryCollectionViewCell.self)
        collectionView.registerCell(HomeInsuranceCostCollectionViewCell.self)
        collectionView.registerReusableSupplementaryView(HomeInsuranceHeaderView.self, of: UICollectionView.elementKindSectionHeader)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(collectionView)

        setupLayout()
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension HomeInsuranceViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell
        switch indexPath.section {
        case 1:
            let homeInsuranceBeneficiaryCollectionViewCell = collectionView.dequeueCell(HomeInsuranceBeneficiaryCollectionViewCell.self, indexPath: indexPath)
            homeInsuranceBeneficiaryCollectionViewCell.configure(insurance)
            cell = homeInsuranceBeneficiaryCollectionViewCell
        case 2:
            let homeInsuranceCostCollectionViewCell = collectionView.dequeueCell(HomeInsuranceCostCollectionViewCell.self, indexPath: indexPath)
            homeInsuranceCostCollectionViewCell.configure(insurance)
            cell = homeInsuranceCostCollectionViewCell
        default:
            let homeInsuranceCollectionViewCell = collectionView.dequeueCell(HomeInsuranceCollectionViewCell.self, indexPath: indexPath)
            let provider = storeController.providerStore[insurance.insuranceProviderName]
            homeInsuranceCollectionViewCell.configure(insurance, provider: provider)
            cell = homeInsuranceCollectionViewCell
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            selectedIndexPath = indexPath
            coordinator?.showinsuranceDetail(insurance)
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let homeInsuranceHeaderView =
                collectionView.dequeueReusableSupplementaryView(HomeInsuranceHeaderView.self, of: kind, indexPath: indexPath)
            homeInsuranceHeaderView.configure(insurance)
            return homeInsuranceHeaderView
        } else {
            return UICollectionReusableView()
        }
    }
}

extension HomeInsuranceViewController {
    private func makeHomeInsuranceLayout() -> UICollectionViewLayout {
        let sections = [makeHomeInsuranceSection(), makeInsuranceBeneficiarySection(), makeInsuranceCostSection()]

        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) in
            return sections[sectionIndex]
        }
        return layout
    }

    private func makeHomeInsuranceSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(420))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(420))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let cardSection = NSCollectionLayoutSection(group: group)
        cardSection.interGroupSpacing = 24
        cardSection.boundarySupplementaryItems = [UICollectionViewCompositionalLayout.makeSectionHeaderElement()]
        cardSection.contentInsets = .init(top: 36, leading: 16, bottom: 0, trailing: 16)
        return cardSection
    }

    private func makeInsuranceBeneficiarySection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(128))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(128))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let beneficiarySection = NSCollectionLayoutSection(group: group)
        beneficiarySection.contentInsets = .init(top: 48, leading: 16, bottom: 0, trailing: 16)
        return beneficiarySection
    }

    private func makeInsuranceCostSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let costSection = NSCollectionLayoutSection(group: group)
        costSection.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
        return costSection
    }
}
