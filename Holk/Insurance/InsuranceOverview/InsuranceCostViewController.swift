//
//  InsuranceCostViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2019-06-16.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

final class InsuranceCostViewController: UIViewController {
    // MARK: - Public variables
    var insuranceCostDetailCoordinator: InsuranceCostDetailCoordinator?
    var tableView = UITableView()

    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
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
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.alwaysBounceVertical = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        let insuranceCostTableViewCell = UINib(nibName: InsuranceCostTableViewCell.identifier, bundle: nil)
        tableView.register(insuranceCostTableViewCell, forCellReuseIdentifier: InsuranceCostTableViewCell.identifier)

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        insuranceCostDetailCoordinator = InsuranceCostDetailCoordinator(navController: navigationController ?? UINavigationController())
        insuranceCostDetailCoordinator?.start()
    }
}

// MARK: - UITableViewDelegate
extension InsuranceCostViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        insuranceCostDetailCoordinator?.showDetail()
    }
}

// MARK: - UITableViewDataSource
extension InsuranceCostViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InsuranceCostTableViewCell.identifier, for: indexPath)
        return cell
    }
}
