//
//  InsurancesViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2019-06-11.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

protocol InsurancesViewControllerDelegate: AnyObject {
    func insurancesViewController(_ viewController: InsurancesViewController, didScroll scrollView: UIScrollView)
}

final class InsurancesViewController: UIViewController {
    // MARK: - IBOutlets
    private let tableView = UITableView()
    // MARK: - Public variables
    var storeController: StoreController
    weak var delegate: InsurancesViewControllerDelegate?
    // MARK: - Public variables
    private enum Section: Int, CaseIterable {
        case insurance
        case addMore
    }

    init(storeController: StoreController) {
        self.storeController = storeController

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var numberOfInsurances = 2
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        view.backgroundColor = .clear
        view.layoutMargins = .init(top: 8, left: 8, bottom: 0, right: 8)

        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 340
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.contentInset = .zero
        tableView.showsVerticalScrollIndicator = false
        tableView.alwaysBounceVertical = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableView.register(InsuranceTableViewCell.self, forCellReuseIdentifier: InsuranceTableViewCell.identifier)
        tableView.register(InsuranceAddMoreCell.self, forCellReuseIdentifier: InsuranceAddMoreCell.identifier)

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource
extension InsurancesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Section.insurance.rawValue: return numberOfInsurances
        case Section.addMore.rawValue: return 1
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case Section.insurance.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: InsuranceTableViewCell.identifier, for: indexPath)
            // TODO: Configure this
            if let insuranceTableViewCell = cell as? InsuranceTableViewCell {
//                insuranceTableViewCell.configureCell(pro)
            }
            return cell
        case Section.addMore.rawValue:
            return tableView.dequeueReusableCell(withIdentifier: InsuranceAddMoreCell.identifier, for: indexPath)
        default: return UITableViewCell()
        }
    }
}

extension InsurancesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case Section.addMore.rawValue:
            numberOfInsurances += 1
            tableView.reloadData()
        default:
            return
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentSize.height > view.frame.height {
            delegate?.insurancesViewController(self, didScroll: scrollView)
        }
    }
}
