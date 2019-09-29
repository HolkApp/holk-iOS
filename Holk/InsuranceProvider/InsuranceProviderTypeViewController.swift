//
//  InsuranceProviderTypeViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2019-09-29.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

final class InsuranceProviderTypeViewController: UIViewController {
    private let tableView = UITableView()
    private let skipButton = HolkButton()
    
    override func viewDidLoad() {
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Pick insurance to find gaps in"
        
        setup()
    }
    
    private func setup() {
        skipButton.setTitle("Hoppa över", for: UIControl.State())
        skipButton.setTitleColor(Color.mainHighlightColor, for: UIControl.State())
        skipButton.titleLabel?.font = Font.regular(.subtitle)
        if #available(iOS 13.0, *) {
            skipButton.layer.cornerCurve = .continuous
        } else {
            skipButton.layer.cornerRadius = 10
        }
        skipButton.layer.borderWidth = 2
        skipButton.layer.borderColor = Color.mainHighlightColor.cgColor
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        view.addSubview(skipButton)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: skipButton.topAnchor),
            
            skipButton.heightAnchor.constraint(equalToConstant: 50),
            skipButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 45),
            skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -45),
            skipButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}

extension InsuranceProviderTypeViewController: UITableViewDelegate {
    
}

extension InsuranceProviderTypeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return InsuranceProviderType.mockTypeResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = InsuranceProviderType.mockTypeResults[indexPath.item].rawValue
        return cell
    }
    
    
}
