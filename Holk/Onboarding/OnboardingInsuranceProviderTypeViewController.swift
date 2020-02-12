//
//  OnboardingInsuranceProviderTypeViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2019-09-30.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

final class OnboardingInsuranceProviderTypeViewController: UIViewController {
    // MARK: Private Variables
    private let headerLabel = UILabel()
    private let tableView = UITableView(frame: .zero, style: .plain)
    private var storeController: StoreController
    
    // MARK: Public Variables
    weak var coordinator: OnboardingCoordinator?
    
    init(storeController: StoreController) {
        self.storeController = storeController
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Start finding your gaps"
        
        setup()
    }
    
    private func setup() {
        view.backgroundColor = Color.mainBackgroundColor
        
        headerLabel.font = Font.bold(.header)
        headerLabel.textColor = Color.mainForegroundColor
        headerLabel.textAlignment = .left
        headerLabel.text = "Pick insurance"
        headerLabel.numberOfLines = 0
            
        tableView.register(OnboardingInsuranceCell.self, forCellReuseIdentifier: "Cell")
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = Color.secondaryForegroundColor
        tableView.alwaysBounceVertical = false
        tableView.estimatedRowHeight = 72
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        view.addSubview(headerLabel)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let tableViewHeight: CGFloat = InsuranceProviderType.mockTypeResults.count * 72 > 600 ? 600 : CGFloat(InsuranceProviderType.mockTypeResults.count * 72)
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            headerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: tableViewHeight),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func select(providerType: InsuranceProviderType) {
        
    }
}

extension OnboardingInsuranceProviderTypeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let providerType = InsuranceProviderType.mockTypeResults[indexPath.item]
        select(providerType: providerType)
    }
}

extension OnboardingInsuranceProviderTypeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return InsuranceProviderType.mockTypeResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let onboardingInsuranceCell = cell as? OnboardingInsuranceCell {
            onboardingInsuranceCell.titleLabel.text = InsuranceProviderType.mockTypeResults[indexPath.item].rawValue
            if indexPath.item != 0 {
                onboardingInsuranceCell.isUpcoming = true
            }
        }
        return cell
    }
}
