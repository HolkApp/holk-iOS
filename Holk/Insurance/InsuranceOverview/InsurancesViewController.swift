//
//  InsurancesViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2019-06-11.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

final class InsurancesViewController: UIViewController {
    // MARK: - Public variables
    var storeController: StoreController
    weak var coordinator: InsuranceCoordinator?

    // MARK: - Private variables
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    private let layout = DynamicHeightCollectionFlowLayout()

    // TODO: Remove the mock
    var numberOfInsurances = 1 {
        didSet {
            collectionView.reloadData()
        }
    }

    init(storeController: StoreController) {
        self.storeController = storeController

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
        view.backgroundColor = .clear
        view.layoutMargins = .zero

        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize

        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.register(InsuranceCollectionViewCell.self, forCellWithReuseIdentifier: InsuranceCollectionViewCell.identifier)
        collectionView.register(InsuranceAddMoreCell.self, forCellWithReuseIdentifier: InsuranceAddMoreCell.identifier)

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

// MARK: - UITableViewDataSource
extension InsurancesViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfInsurances
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            InsuranceCollectionViewCell.identifier, for: indexPath)
        // TODO: Configure this
        if let insuranceTableViewCell = cell as? InsuranceCollectionViewCell {
//            insuranceTableViewCell.configureCell(provider)
        }
        return cell
    }
}

extension InsurancesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: Use real insurance
        let insurance = Insurance(id: "1", insuranceProvider: "1", insuranceType: "1", issuerReference: "", ssn: "", startDate: Date(), endDate: Date(), username: "")
        coordinator?.showInsurnaceDetail(insurance)
    }
}
