//
//  OnboardingInsuranceTypeViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2019-09-30.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

protocol OnboardingInsuranceTypeViewControllerDelegate: AnyObject {
    func onboardingInsuranceProviderType(_ viewController: OnboardingInsuranceTypeViewController, didSelect providerType: InsuranceProviderType)
}

final class OnboardingInsuranceTypeViewController: UIViewController {
    // MARK: Private Variables
    private let headerLabel = UILabel()
    private let tableView = UITableView(frame: .zero, style: .plain)
    private var storeController: StoreController
    
    // MARK: Public Variables
    weak var delegate: OnboardingInsuranceTypeViewControllerDelegate?
    
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
        navigationItem.title = LocalizedString.Insurance.Aggregate.navigationTitle
        
        view.backgroundColor = Color.mainBackground
        
        headerLabel.font = FontStyleGuide.header2.font
        headerLabel.textColor = Color.mainForeground
        headerLabel.textAlignment = .left
        headerLabel.text = LocalizedString.Insurance.Aggregate.selectInsurance
        headerLabel.numberOfLines = 0
            
        tableView.registerCell(OnboardingInsuranceCell.self)
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = Color.secondaryForeground
        tableView.alwaysBounceVertical = false
        tableView.estimatedRowHeight = 72
        tableView.delegate = self
        tableView.dataSource = self
        
        setupLayout()
    }
    
    private func setupLayout() {
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
        delegate?.onboardingInsuranceProviderType(self, didSelect: providerType)
    }
}

extension OnboardingInsuranceTypeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let providerType = InsuranceProviderType.mockTypeResults[indexPath.item]
        guard !providerType.isUpcoming else { return }
        select(providerType: providerType)
    }
}

extension OnboardingInsuranceTypeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return InsuranceProviderType.mockTypeResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let onboardingInsuranceCell = tableView.dequeueCell(OnboardingInsuranceCell.self, indexPath: indexPath)
        onboardingInsuranceCell.configure(
            title: InsuranceProviderType.mockTypeResults[indexPath.item].rawValue,
            image: UIImage(systemName: "house")?.withRenderingMode(.alwaysTemplate),
            isUpcoming: InsuranceProviderType.mockTypeResults[indexPath.item].isUpcoming
        )
        return onboardingInsuranceCell
    }
}
