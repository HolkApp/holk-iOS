//
//  InsuranceCostViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2019-06-16.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

final class InsuranceCostViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var insuranceDetailCoordinator: InsuranceDetailCoordinator?
    
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
        
        let navController = navigationController ?? UINavigationController()
        insuranceDetailCoordinator = InsuranceDetailCoordinator(navController: navController)
        insuranceDetailCoordinator?.start()
    }
}

// MARK: - UITableViewDelegate
extension InsuranceCostViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Use coordinator
        insuranceDetailCoordinator?.showDetail()
    }
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
