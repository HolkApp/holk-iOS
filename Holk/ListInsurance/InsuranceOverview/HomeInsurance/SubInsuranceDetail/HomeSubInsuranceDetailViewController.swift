//
//  HomeSubInsuranceDetailViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2020-10-11.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class HomeSubInsuranceDetailViewController: UIViewController {
    // MARK: - Private Variables
    private var storeController: StoreController
    private var insurance: Insurance

//    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
//    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

//    private lazy var dataSource = makeDataSource()
    private lazy var collectionView: UICollectionView = {
        let layout = makeDetailLayout()
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
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

    private func setup() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(collectionView)

        setupLayout()
    }

    private func setupLayout() {

    }
}

extension HomeSubInsuranceDetailViewController {
    // TODO: Update
    private func makeDetailLayout() -> UICollectionViewLayout {
        let sections:[NSCollectionLayoutSection] = []

        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) in
            return sections[sectionIndex]
        }
        return layout
    }
}
