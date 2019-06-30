//
//  InsuranceCostViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2019-06-16.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

final class InsuranceCostViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    
    private func setup() {
        view.backgroundColor = Color.mainBackgroundColor
        
        tableView.backgroundColor = .clear
        
        tableView.estimatedRowHeight = 224
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        let insuranceCostTableViewCell = UINib(nibName: InsuranceCostTableViewCell.identifier, bundle: nil)
        tableView.register(insuranceCostTableViewCell, forCellReuseIdentifier: InsuranceCostTableViewCell.identifier)
    }
}

// MARK: - UITableViewDelegate
extension InsuranceCostViewController: UITableViewDelegate {
    
}

extension InsuranceCostViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InsuranceCostTableViewCell.identifier, for: indexPath)
        return cell
    }
    
    
}
