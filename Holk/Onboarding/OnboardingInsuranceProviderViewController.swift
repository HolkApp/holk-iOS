//
//  OnboardingInsuranceProviderViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2019-09-29.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit
import Combine

final class OnboardingInsuranceProviderViewController: UIViewController {
    // MARK: - Public variables
    weak var coordinator: OnboardingCoordinating?
    
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
    
    private func setup() {
        setupLayout()

        navigationItem.title = "Start finding your gaps"
        view.backgroundColor = Color.mainBackgroundColor
        
        headerLabel.font = Font.bold(.header)
        headerLabel.textColor = Color.mainForegroundColor
        headerLabel.textAlignment = .left
        headerLabel.text = "Pick insurance company"
        headerLabel.numberOfLines = 0
        
        tableView.register(OnboardingInsuranceCell.self, forCellReuseIdentifier: "Cell")
        tableView.alwaysBounceVertical = false
        tableView.separatorColor = Color.secondaryForegroundColor
        tableView.backgroundColor = Color.mainBackgroundColor
        tableView.delegate = self
        tableView.dataSource = self

        loadInsuranceProviderListIfNeeded()

        storeController.insuranceProviderStore.providerList.sink { [weak self] list in
            self?.tableViewHeightAnchor?.constant = list.count * 72 > 600 ? 600 : CGFloat(list.count * 72)
            self?.tableView.reloadData()
        }.store(in: &cancellables)
    }
    
    private func setupLayout() {
        view.addSubview(headerLabel)
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.translatesAutoresizingMaskIntoConstraints = false

        let tableViewHeightAnchor = tableView.heightAnchor.constraint(equalToConstant: 0)
        self.tableViewHeightAnchor = tableViewHeightAnchor
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            headerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableViewHeightAnchor,
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func loadInsuranceProviderListIfNeeded() {
        switch storeController.insuranceProviderStore.providerList.value.count {
        case 0:
            storeController.insuranceProviderStore.fetchInsuranceProviders { _ in }
        default:
            return
        }
    }
    
    private func select(_ insuranceProvider: InsuranceProvider) {
        coordinator?.addInsuranceProvider(insuranceProvider)
    }
}

extension OnboardingInsuranceProviderViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let list = storeController.insuranceProviderStore.providerList.value
        select(list[indexPath.item])
    }
}

extension OnboardingInsuranceProviderViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let list = storeController.insuranceProviderStore.providerList.value
        switch list.count {
        case 0:
            return 1
        default:
            return list.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let list = storeController.insuranceProviderStore.providerList.value
        switch list.count {
        case 0:
            cell.textLabel?.text = "loading"
        default:
            if let onboardingInsuranceCell = cell as? OnboardingInsuranceCell {
                let provider = list[indexPath.item]
                UIImage.imageWithUrl(imageUrlString: provider.logoUrl) { image in
                    onboardingInsuranceCell.configure(title: provider.displayName, image: image)
                }
            }
        }
        return cell
    }
}
