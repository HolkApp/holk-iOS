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
    private var insuranceList: [Insurance] {
        didSet {
            collectionView.reloadData()
        }
    }

    private var cancellables = Set<AnyCancellable>()

    init(storeController: StoreController, collectionViewLayout: UICollectionViewLayout) {
        self.storeController = storeController
        insuranceList = storeController.insuranceStore.insuranceList.value

        super.init(collectionViewLayout: collectionViewLayout)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
//        storeController.insuranceStore.insuranceList.sink { [weak self] in
//            self?.insurnaceList = $0
//        }.store(in: &cancellables)
        insuranceList = [AllInsuranceResponse.mockInsurnace]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.barTintColor = Color.insuranceBackgroundColor
        navigationController?.navigationBar.shadowImage = nil
    }
    
    private func setup() {
        title = "Försäkringar"
        let largeTitleFont = Font.font(name: .poppins, weight: .semiBold, size: 30)
        navigationController?.navigationBar.largeTitleTextAttributes = [.font: largeTitleFont]
        let titleFont = Font.font(name: .poppins, weight: .semiBold, size: 20)
        navigationController?.navigationBar.titleTextAttributes = [.font: titleFont]
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.crop.circle"), style: .plain, target: self, action: #selector(profileTapped(sender:)))

        view.backgroundColor = Color.insuranceBackgroundColor
        view.layoutMargins = .zero

        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        collectionView.register(InsuranceCollectionViewCell.self, forCellWithReuseIdentifier: InsuranceCollectionViewCell.identifier)
        collectionView.register(InsuranceSuggestionCardCollectionViewCell.self, forCellWithReuseIdentifier: InsuranceSuggestionCardCollectionViewCell.identifier)
    }

    @objc private func profileTapped(sender: UIButton) {
        coordinator?.logout()
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
            let insuranceSuggestionCardCollectionViewCell = collectionView.dequeueCell(ofType: InsuranceSuggestionCardCollectionViewCell.self, indexPath: indexPath)
            if indexPath.item == 0 {
                insuranceSuggestionCardCollectionViewCell.configure(nil, suggestionType: .reminder)
            } else {
                insuranceSuggestionCardCollectionViewCell.configure(nil, suggestionType: .thinkOf)
            }
            return insuranceSuggestionCardCollectionViewCell
        } else {
            let insuranceTableViewCell = collectionView.dequeueCell(ofType: InsuranceCollectionViewCell.self, indexPath: indexPath)
            let insurance = insuranceList[indexPath.item]
            insuranceTableViewCell.configure(insurance)
            return insuranceTableViewCell
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: Update this with real insurance
        if indexPath.section == 0 {
            if indexPath.item == 0 {
                let insuranceGapsSuggestionViewController = InsuranceGapsSuggestionViewController(storeController: storeController)
                insuranceGapsSuggestionViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancel(_:)))
                present(UINavigationController(rootViewController: insuranceGapsSuggestionViewController), animated: true)
            } else {
                let insuranceThinkOfSuggestionViewController = InsuranceThinkOfSuggestionViewController()
                insuranceThinkOfSuggestionViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancel(_:)))
                present(UINavigationController(rootViewController: insuranceThinkOfSuggestionViewController), animated: true)
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
