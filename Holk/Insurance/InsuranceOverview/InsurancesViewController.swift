//
//  InsurancesViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2019-06-11.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

protocol InsurancesViewControllerDelegate: AnyObject {
    func InsurancesViewController(_ viewController: InsurancesViewController, didScroll scrollView: UIScrollView)
}

final class InsurancesViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    // MARK: - Public variables
    weak var delegate: InsurancesViewControllerDelegate?
    // MARK: - Public variables
    private enum Section: Int, CaseIterable {
        case insurance
        case addMore
    }
    private var numberOfInsurances = 2
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        view.backgroundColor = .clear
        tableView.backgroundColor = .clear

        tableView.estimatedRowHeight = 340
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.showsVerticalScrollIndicator = false
        tableView.alwaysBounceVertical = false

        tableView.register(InsuranceTableViewCell.self, forCellReuseIdentifier: InsuranceTableViewCell.identifier)
        tableView.register(InsuranceAddMoreCell.self, forCellReuseIdentifier: InsuranceAddMoreCell.identifier)
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
            if let insuranceTableViewCell = cell as? InsuranceTableViewCell {
                insuranceTableViewCell.configureCell()
            }
            return cell
        case Section.addMore.rawValue:
            return tableView.dequeueReusableCell(withIdentifier: InsuranceAddMoreCell.identifier, for: indexPath)
        default: return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case Section.insurance.rawValue:
            return 340
        case Section.addMore.rawValue:
            return 145
        default:
            return 0
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
            delegate?.InsurancesViewController(self, didScroll: scrollView)
        }
    }
}
