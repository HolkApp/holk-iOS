//
//  OnboardingInsuranceIssuerViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2019-09-29.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit
import RxSwift

final class OnboardingInsuranceIssuerViewController: UIViewController {
    // MARK: - Public variables
    weak var coordinator: OnboardingCoordinating?
    
    // MARK: - Private variables
    private let headerLabel = UILabel()
    private var storeController: StoreController
    private let tableView = UITableView()
    private let bag = DisposeBag()
    
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
        subscribeInsurnaceIssuerChanges()
        loadInsuranceIssuerListIfNeeded()
        
        view.backgroundColor = Color.mainBackgroundColor
        headerLabel.font = Font.bold(.header)
        headerLabel.textColor = Color.mainForegroundColor
        headerLabel.textAlignment = .left
        headerLabel.text = "Pick Insurance Issuer"
        headerLabel.numberOfLines = 0
        
        tableView.register(OnboardingInsuranceCell.self, forCellReuseIdentifier: "Cell")
        tableView.alwaysBounceVertical = false
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(headerLabel)
        view.addSubview(tableView)
        
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
    
    private func subscribeInsurnaceIssuerChanges() {
        storeController.insuranceStore.insuranceIssuerList
            .subscribe({ [weak self] _ in self?.tableView.reloadData() })
            .disposed(by: bag)
    }
    
    private func loadInsuranceIssuerListIfNeeded() {
        switch storeController.insuranceStore.insuranceIssuerList.value {
        case .loading, .error:
            storeController.insuranceStore.loadInsuranceIssuers()
        default:
            break
        }
    }
    
    private func select(_ insuranceIssuer: InsuranceIssuer) {
        coordinator?.addInsuranceIssuer(insuranceIssuer)
    }
}

extension OnboardingInsuranceIssuerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let list = storeController.insuranceStore.insuranceIssuerList.value
        switch list {
        case .loaded(let insuranceIssuerList):
            select(insuranceIssuerList.insuranceIssuers[indexPath.item])
        default:
            break
        }
    }
}

extension OnboardingInsuranceIssuerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let list = storeController.insuranceStore.insuranceIssuerList.value
        switch list {
        case .loaded(let insuranceIssuerList):
            return insuranceIssuerList.insuranceIssuers.count
        case .loading:
            return 1
        case .error:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let list = storeController.insuranceStore.insuranceIssuerList.value
        switch list {
        case .loaded(let insuranceIssuerList):
            if let onboardingInsuranceCell = cell as? OnboardingInsuranceCell {
                onboardingInsuranceCell.configure(
                    title: insuranceIssuerList.insuranceIssuers[indexPath.item].displayName,
                    image: UIImage(systemName: "circle")?.withRenderingMode(.alwaysTemplate)
                )
            }
        case .loading:
            cell.textLabel?.text = "loading"
        case .error:
            break
        }
        return cell
    }
}
