//
//  InsuranceProviderTypeViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2019-09-29.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

final class InsuranceProviderTypeViewController: UIViewController {
    // MARK: - Public variables
    weak var coordinator: OnboardingCoordinator?
    
    // MARK: - Private variables
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
        tableView.alwaysBounceVertical = false
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        view.addSubview(skipButton)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.addTarget(self, action: #selector(confirmSkip(_:)), for: .touchUpInside)
        
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
    
    @objc private func confirmSkip(_ sender: UIButton) {
        let alert = UIAlertController(
            title: "Are you sure you want to skip?",
            message: "We won't be able to find the gaps in your insurance",
            preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(
                title: "Yes, skip",
                style: .default,
                handler: { [weak self] action in
                    self?.confirm()
            })
        )
        alert.addAction(UIAlertAction(title: "No, go back", style: .cancel))
        present(alert, animated: true)
    }
    
    private func confirm() {
        let confirmedViewController = StoryboardScene.Onboarding.onboardingSignupConfirmedViewController.instantiate()
        confirmedViewController.modalPresentationStyle = .overFullScreen
        present(
            confirmedViewController,
            animated: true
        )
    }
    
    private func select(_ providerType: InsuranceProviderType) {
        let insuranceProviderViewController = StoryboardScene.Onboarding.insuranceProviderViewController.instantiate()
        insuranceProviderViewController.modalPresentationStyle = .overFullScreen
        navigationController?.pushViewController(insuranceProviderViewController, animated: true)
    }
}

extension InsuranceProviderTypeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        select(InsuranceProviderType.mockTypeResults[indexPath.item])
    }
}

extension InsuranceProviderTypeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return InsuranceProviderType.mockTypeResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = InsuranceProviderType.mockTypeResults[indexPath.item].rawValue
        cell.selectionStyle = .none
        return cell
    }
}
