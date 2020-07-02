//
//  InsuranceSubmodelDetailViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2020-07-01.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class InsuranceSubmodelDetailViewController: UIViewController {
    // MARK: - Public Variables
    var storeController: StoreController

    private lazy var collectionView: UICollectionView = {
        let onboardingLayoutSection = UICollectionViewCompositionalLayout.makeOnboardingViewSection()
        let layout = UICollectionViewCompositionalLayout(section: onboardingLayoutSection)
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()

    // MARK: - Init
    init(storeController: StoreController) {
        self.storeController = storeController

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
