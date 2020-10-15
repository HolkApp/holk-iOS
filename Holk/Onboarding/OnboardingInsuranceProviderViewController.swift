//
//  OnboardingInsuranceProviderViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2019-09-29.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit
import Combine

protocol OnboardingInsuranceProviderViewControllerDelegate: AnyObject {
    func onboardingInsuranceProvider(_ viewController: OnboardingInsuranceProviderViewController, didSelect provider: InsuranceProvider)
}

final class OnboardingInsuranceProviderViewController: UIViewController {
    // MARK: - Public variables
    weak var delegate: OnboardingInsuranceProviderViewControllerDelegate?
    
    // MARK: - Private variables
    private var storeController: StoreController
    private var cancellables = Set<AnyCancellable>()

    private let headerLabel = UILabel()
    private let tableView = UITableView()
    private var tableViewHeightAnchor: NSLayoutConstraint?
    
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let listNumber =  storeController.providerStore.providerList.value?.count ?? 0
        let listContentHeight = CGFloat(listNumber * 72)
        if tableView.frame.height > listContentHeight {
            tableView.contentInset.top = tableView.frame.height - listContentHeight + 8
            tableView.isScrollEnabled = false
        } else {
            tableView.contentInset.top = 8
            tableView.isScrollEnabled = true
        }
    }
    
    private func setup() {
        setupLayout()

        navigationItem.title = LocalizedString.Insurance.Aggregate.navigationTitle
        view.backgroundColor = Color.mainBackground
        
        headerLabel.font = FontStyleGuide.header2.font
        headerLabel.textColor = Color.mainForeground
        headerLabel.textAlignment = .left
        headerLabel.text = LocalizedString.Insurance.Aggregate.selectInsuranceProvider
        headerLabel.numberOfLines = 0
        
        tableView.registerCell(OnboardingInsuranceCell.self)
        tableView.alwaysBounceVertical = false
        tableView.separatorColor = Color.secondaryForeground
        tableView.backgroundColor = Color.mainBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = .init(top: 8, left: 0, bottom: 8, right: 0)

        loadInsuranceProviderListIfNeeded()

        storeController.providerStore.providerList.sink { [weak self] list in
            self?.view.setNeedsLayout()
            self?.tableView.reloadData()
        }.store(in: &cancellables)
    }
    
    private func setupLayout() {
        view.addSubview(headerLabel)
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            headerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(lessThanOrEqualTo: headerLabel.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func loadInsuranceProviderListIfNeeded() {
        if storeController.providerStore.providerList.value == nil {
            storeController.providerStore.fetchInsuranceProviders()
        }
    }
    
    private func select(_ insuranceProvider: InsuranceProvider) {
        delegate?.onboardingInsuranceProvider(self, didSelect: insuranceProvider)
    }
}

extension OnboardingInsuranceProviderViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let list = storeController.providerStore.providerList.value {
            select(list[indexPath.item])
        }
    }
}

extension OnboardingInsuranceProviderViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let list = storeController.providerStore.providerList.value
        return list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let onboardingInsuranceCell = tableView.dequeueCell(OnboardingInsuranceCell.self, indexPath: indexPath)
        if let list = storeController.providerStore.providerList.value {
            let provider = list[indexPath.item]
            onboardingInsuranceCell.configure(title: provider.displayName, imageURL: provider.symbolUrl)
        } else {
            // TODO: Have some loading state
            onboardingInsuranceCell.textLabel?.text = "loading"
        }
        return onboardingInsuranceCell
    }
}
