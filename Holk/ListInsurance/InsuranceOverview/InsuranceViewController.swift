//
//  InsuranceViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2020-05-31.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class InsuranceViewController: UIViewController {
    // MARK: - Public Variables
    weak var coordinator: InsuranceCoordinator?
    var selectedIndexPath: IndexPath?
    lazy var collectionView: UICollectionView = {
        let insuranceLayout = UICollectionViewCompositionalLayout.makeHomeInsuranceLayout()
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

        navigationController?.navigationBar.barTintColor = Color.secondaryBackground
    }

    private func setup() {
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = Color.secondaryBackground

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        collectionView.register(HomeinsuranceCollectionViewCell.self, forCellWithReuseIdentifier: HomeinsuranceCollectionViewCell.identifier)
        collectionView.register(HomeInsuranceBeneficiaryCollectionViewCell.self, forCellWithReuseIdentifier: HomeInsuranceBeneficiaryCollectionViewCell.identifier)
        collectionView.register(HomeInsuranceCostCollectionViewCell.self, forCellWithReuseIdentifier: HomeInsuranceCostCollectionViewCell.identifier)
        collectionView.register(HomeInsuranceHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeInsuranceHeaderView.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(collectionView)

        setupCosntraints()
    }

    private func setupCosntraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension InsuranceViewController: UICollectionViewDataSource, UICollectionViewDelegate {
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
            let homeInsuranceBeneficiaryCollectionViewCell = collectionView.dequeueCell(ofType: HomeInsuranceBeneficiaryCollectionViewCell.self, indexPath: indexPath)
            homeInsuranceBeneficiaryCollectionViewCell.configure(insurance)
            cell = homeInsuranceBeneficiaryCollectionViewCell
        case 2:
            let homeInsuranceCostCollectionViewCell = collectionView.dequeueCell(ofType: HomeInsuranceCostCollectionViewCell.self, indexPath: indexPath)
            homeInsuranceCostCollectionViewCell.configure(insurance)
            cell = homeInsuranceCostCollectionViewCell
        default:
            let homeinsuranceCollectionViewCell = collectionView.dequeueCell(ofType: HomeinsuranceCollectionViewCell.self, indexPath: indexPath)
            homeinsuranceCollectionViewCell.configure(insurance)
            cell = homeinsuranceCollectionViewCell
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
            let insuranceSuggestionHeaderView =
                collectionView.dequeueHeaderFooterView(type: HomeInsuranceHeaderView.self, of: kind, indexPath: indexPath)
            insuranceSuggestionHeaderView.configure(insurance)
            return insuranceSuggestionHeaderView
        } else {
            return UICollectionReusableView()
        }
    }
}
