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
    private var suggestions: SuggestionsListResponse? {
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

        storeController.insuranceStore.insuranceList
            .sink { [weak self] in self?.insuranceList = $0 }
            .store(in: &cancellables)
        storeController.suggestionStore.suggestions
            .sink { [weak self] in self?.suggestions = $0 }
            .store(in: &cancellables)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationItem.largeTitleDisplayMode = .always
        
        navigationController?.navigationBar.layoutMargins.left = 24
        navigationController?.navigationBar.layoutMargins.right = 24
        navigationController?.navigationBar.barTintColor = Color.insuranceBackground
        navigationController?.navigationBar.shadowImage = UIImage()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.navigationBar.layoutMargins.left = 16
        navigationController?.navigationBar.layoutMargins.right = 16
    }
    
    private func setup() {
        title = "Försäkringar"

        let largeTitleFont = Font.font(name: .poppins, weight: .semiBold, size: 30)
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .font: largeTitleFont,
            .foregroundColor: Color.mainForeground
        ]
        let titleFont = Font.font(name: .poppins, weight: .semiBold, size: 20)
        navigationController?.navigationBar.titleTextAttributes = [
            .font: titleFont,
            .foregroundColor: Color.mainForeground
        ]
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "profile"), style: .plain, target: self, action: #selector(profileTapped(sender:)))
        navigationItem.setAppearance(backgroundColor: Color.insuranceBackground)

        view.backgroundColor = Color.insuranceBackground
        view.layoutMargins = .zero

        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        collectionView.registerCell(InsuranceCollectionViewCell.self)
        collectionView.registerCell(InsuranceSuggestionCardCollectionViewCell.self)
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
            let insuranceSuggestionCardCollectionViewCell = collectionView.dequeueCell(InsuranceSuggestionCardCollectionViewCell.self, indexPath: indexPath)
            if indexPath.item == 0 {
                insuranceSuggestionCardCollectionViewCell.configure(suggestions, suggestionType: .gap)
            } else {
                insuranceSuggestionCardCollectionViewCell.configure(suggestions, suggestionType: .thinkOf)
            }
            return insuranceSuggestionCardCollectionViewCell
        } else {
            let insuranceTableViewCell = collectionView.dequeueCell(InsuranceCollectionViewCell.self, indexPath: indexPath)
            let insurance = insuranceList[indexPath.item]
            insuranceTableViewCell.configure(insurance)
            return insuranceTableViewCell
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: Update this with real insurance
        if indexPath.section == 0 {
            if indexPath.item == 0 {
                let insuranceGapsViewController = InsuranceGapsViewController(storeController: storeController)
                insuranceGapsViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancel(_:)))
                present(UINavigationController(rootViewController: insuranceGapsViewController), animated: true)
            } else {
                let insuranceThinkOfsViewController = InsuranceThinkOfsViewController(storeController: storeController)
                insuranceThinkOfsViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancel(_:)))
                present(UINavigationController(rootViewController: insuranceThinkOfsViewController), animated: true)
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
