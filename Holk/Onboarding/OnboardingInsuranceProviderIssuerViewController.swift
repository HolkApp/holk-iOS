//
//  OnboardingInsuranceProviderIssuerViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2019-09-29.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit
import RxSwift

final class OnboardingInsuranceProviderIssuerViewController: UIViewController {
    // MARK: - Public variables
    weak var coordinator: OnboardingCoordinator?
    
    // MARK: - Private variables
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
        storeController.insuranceStore.insuranceIssuerList
            .subscribe({ [weak self] _ in self?.tableView.reloadData() })
            .disposed(by: bag)
        loadInsuranceIssuerListIfNeeded()
        
        tableView.register(OnboardingInsuranceCell.self, forCellReuseIdentifier: "Cell")
        tableView.alwaysBounceVertical = false
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        view.backgroundColor = .white
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
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
        let insuranceProviderViewController = OnboardingInsuranceProviderTypeViewController(storeController: storeController)
        insuranceProviderViewController.coordinator = coordinator
        insuranceProviderViewController.modalPresentationStyle = .overFullScreen
        navigationController?.pushViewController(insuranceProviderViewController, animated: true)
    }
}

extension OnboardingInsuranceProviderIssuerViewController: UITableViewDelegate {
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

extension OnboardingInsuranceProviderIssuerViewController: UITableViewDataSource {
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
            cell.textLabel?.text = insuranceIssuerList.insuranceIssuers[indexPath.item].displayName
            cell.selectionStyle = .none
        case .loading:
            cell.textLabel?.text = "loading"
        case .error:
            break
        }
        return cell
    }
}
