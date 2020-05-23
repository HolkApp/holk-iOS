//
//  InsurancesViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2019-06-11.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit
import Combine

final class InsurancesViewController: UICollectionViewController {
    // MARK: - Public variables
    var selectedIndexPath: IndexPath?
    weak var coordinator: InsuranceCoordinator?

    // MARK: - Private variables
    private var storeController: StoreController
    private var insurnaceList: [Insurance] {
        didSet {
            collectionView.reloadData()
        }
    }

    private var cancellables = Set<AnyCancellable>()

    init(storeController: StoreController, collectionViewLayout: UICollectionViewLayout) {
        self.storeController = storeController
        insurnaceList = storeController.insuranceStore.insuranceList.value

        super.init(collectionViewLayout: collectionViewLayout)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        storeController.insuranceStore.insuranceList.sink { [weak self] in
            self?.insurnaceList = $0
        }.store(in: &cancellables)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.barTintColor = Color.backgroundColor
    }
    
    private func setup() {
        let largeTitleFont = Font.font(name: .poppins, weight: .semiBold, size: 30)
        navigationController?.navigationBar.largeTitleTextAttributes = [.font: largeTitleFont]
        let titleFont = Font.font(name: .poppins, weight: .semiBold, size: 20)
        navigationController?.navigationBar.titleTextAttributes = [.font: titleFont]
        title = "Översikt"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.crop.circle"), style: .plain, target: self, action: #selector(profileTapped(sender:)))

        view.backgroundColor = Color.backgroundColor
        view.layoutMargins = .zero

        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        collectionView.register(InsuranceCollectionViewCell.self, forCellWithReuseIdentifier: InsuranceCollectionViewCell.identifier)
        collectionView.register(InsuranceHintCardCollectionViewCell.self, forCellWithReuseIdentifier: InsuranceHintCardCollectionViewCell.identifier)
    }

    @objc private func profileTapped(sender: UIButton) {
        coordinator?.logout()
    }
}

// MARK: - UITableViewDataSource and UICollectionViewDelegate
extension InsurancesViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            return insurnaceList.count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            InsuranceHintCardCollectionViewCell.identifier, for: indexPath)
            if let insuranceHintCardCollectionViewCell = cell as? InsuranceHintCardCollectionViewCell {
                if indexPath.item == 0 {
                    insuranceHintCardCollectionViewCell.configure(nil, hintType: .reminder)
                } else {
                    insuranceHintCardCollectionViewCell.configure(nil, hintType: .thinkOf)
                }
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
                        InsuranceCollectionViewCell.identifier, for: indexPath)
            if let insuranceTableViewCell = cell as? InsuranceCollectionViewCell {
                let insurance = insurnaceList[indexPath.item]
                insuranceTableViewCell.configure(insurance)
            }
            return cell
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: Update this with real insurance
        if indexPath.section == 0 {
            if indexPath.item == 0 {
                let viewController = UIViewController()
                viewController.title = "Reminder"
                viewController.view.backgroundColor = .white
                present(UINavigationController(rootViewController: viewController), animated: true)
            } else {
                let viewController = UIViewController()
                viewController.title = "Think Of"
                viewController.view.backgroundColor = .white
                present(UINavigationController(rootViewController: viewController), animated: true)
            }
        } else {
            selectedIndexPath = indexPath
            let insurance = insurnaceList[indexPath.item]
            coordinator?.showInsurnaceDetail(insurance)
        }
    }
}
