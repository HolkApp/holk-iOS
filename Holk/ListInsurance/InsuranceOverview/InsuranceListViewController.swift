//
//  InsuranceListViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2019-06-11.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit
import Combine

final class InsuranceListViewController: UICollectionViewController {
    // MARK: - Public variables
    var selectedIndexPath: IndexPath?
    weak var coordinator: InsuranceCoordinator?

    // MARK: - Private variables
    private var storeController: StoreController
    private var gaps: [GapSuggestion] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    private var thinkOfs: [ThinkOfSuggestion] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    private var insuranceList: [Insurance] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    private var cancellables = Set<AnyCancellable>()

    init(storeController: StoreController, collectionViewLayout: UICollectionViewLayout) {
        self.storeController = storeController

        super.init(collectionViewLayout: collectionViewLayout)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()

        storeController.insuranceStore.$homeInsurances
            .sink { [weak self] in self?.insuranceList = $0 }
            .store(in: &cancellables)
        storeController.suggestionStore.$gaps
            .sink { [weak self] in self?.gaps = $0 }
            .store(in: &cancellables)
        storeController.suggestionStore.$thinkOfs
            .sink { [weak self] in self?.thinkOfs = $0 }
            .store(in: &cancellables)
    }
    
    private func setup() {
        title = LocalizedString.Insurance.text
        navigationItem.setAppearance(backgroundColor: Color.secondaryBackground)

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "profile"), style: .plain, target: self, action: #selector(profileTapped(sender:)))

        collectionView.backgroundColor = Color.secondaryBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.registerCell(InsuranceCollectionViewCell.self)
        collectionView.registerCell(InsuranceSuggestionCardCollectionViewCell.self)
    }

    @objc private func profileTapped(sender: UIButton) {
        coordinator?.showProfile()
    }
}

// MARK: - UITableViewDataSource and UICollectionViewDelegate
extension InsuranceListViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            return insuranceList.count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let insuranceSuggestionCardCollectionViewCell = collectionView.dequeueCell(InsuranceSuggestionCardCollectionViewCell.self, indexPath: indexPath)
            if indexPath.item == 0 {
                insuranceSuggestionCardCollectionViewCell.configure(gaps)
            } else {
                insuranceSuggestionCardCollectionViewCell.configure(thinkOfs)
            }
            return insuranceSuggestionCardCollectionViewCell
        } else {
            let insuranceTableViewCell = collectionView.dequeueCell(InsuranceCollectionViewCell.self, indexPath: indexPath)
            let insurance = insuranceList[indexPath.item]
            let providerName = insurance.insuranceProviderName
            let provider = storeController.providerStore[providerName]
            insuranceTableViewCell.configure(insurance, provider: provider)
            return insuranceTableViewCell
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: Update this with real insurance
        if indexPath.section == 0 {
            if indexPath.item == 0 {
                let gapListViewController = GapListViewController(storeController: storeController)
                gapListViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancel(_:)))
                present(UINavigationController(rootViewController: gapListViewController), animated: true)
            } else {
                let thinkOfListViewController = ThinkOfListViewController(storeController: storeController)
                thinkOfListViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancel(_:)))
                present(UINavigationController(rootViewController: thinkOfListViewController), animated: true)
            }
        } else {
            selectedIndexPath = indexPath
            let insurance = insuranceList[indexPath.item]
            coordinator?.showInsurance(insurance)
        }
    }

    @objc private func cancel(_ sender: Any) {
        dismiss(animated: true)
    }
}
