//
//  InsurancesViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2019-06-11.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

final class InsurancesViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    
    enum Section: Int, CaseIterable {
        case insurance
        case addMore
    }
    
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
    }
}

// MARK: - UITableViewDataSource
extension InsurancesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Section.insurance.rawValue: return 1
        case Section.addMore.rawValue: return 1
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}

extension InsurancesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
