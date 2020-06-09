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
    
    // MARK: - Private Variables
    private var storeController: StoreController
    private var insurance: Insurance
    private lazy var collectionView: UICollectionView = {
        let insuranceLayout = UICollectionViewCompositionalLayout.makeInsuranceLayout()
        return UICollectionView(frame: .zero, collectionViewLayout: insuranceLayout)
    }()

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

        navigationController?.navigationBar.barTintColor = Color.secondaryBackgroundColor
    }

    private func setup() {
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = Color.secondaryBackgroundColor

        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.register(HomeInsurnaceCollectionViewCell.self, forCellWithReuseIdentifier: HomeInsurnaceCollectionViewCell.identifier)
        collectionView.register(HomeInsuranceBeneficiaryCollectionViewCell.self, forCellWithReuseIdentifier: HomeInsuranceBeneficiaryCollectionViewCell.identifier)
        collectionView.register(HomeInsuranceCostCollectionViewCell.self, forCellWithReuseIdentifier: HomeInsuranceCostCollectionViewCell.identifier)
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

extension InsuranceViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell
        switch indexPath.section {
        case 0:
            let homeInsurnaceCollectionViewCell = collectionView.dequeueCell(ofType: HomeInsurnaceCollectionViewCell.self, indexPath: indexPath)
            homeInsurnaceCollectionViewCell.configure(insurance)
            cell = homeInsurnaceCollectionViewCell
        case 1:
            let homeInsuranceBeneficiaryCollectionViewCell = collectionView.dequeueCell(ofType: HomeInsuranceBeneficiaryCollectionViewCell.self, indexPath: indexPath)
            homeInsuranceBeneficiaryCollectionViewCell.configure(insurance)
            cell = homeInsuranceBeneficiaryCollectionViewCell
        case 2:
            let homeInsuranceCostCollectionViewCell = collectionView.dequeueCell(ofType: HomeInsuranceCostCollectionViewCell.self, indexPath: indexPath)
            homeInsuranceCostCollectionViewCell.configure(insurance)
            cell = homeInsuranceCostCollectionViewCell
        default:
            cell = UICollectionViewCell()
        }
        return cell
    }
}
