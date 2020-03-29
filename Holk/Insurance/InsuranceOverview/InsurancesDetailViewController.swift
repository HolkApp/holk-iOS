//
//  InsurancesDetailViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2020-03-29.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

class InsurancesDetailViewController: UIViewController {
    // MARK: - Public variables
    var tableView = UITableView()
    var insurance: Insurance
    
    weak var coordinator: InsuranceCoordinator?

    init(insurance: Insurance) {
        self.insurance = insurance

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

        tableView.register(InsuranceDetailTableViewCell.self, forCellReuseIdentifier: InsuranceDetailTableViewCell.identifier)

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDelegate
extension InsurancesDetailViewController: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource
extension InsurancesDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return insurance.insuranceParts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InsuranceDetailTableViewCell.identifier, for: indexPath)
        return cell
    }
}
