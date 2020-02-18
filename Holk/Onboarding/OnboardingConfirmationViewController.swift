//
//  OnboardingConfirmationViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2020-02-15.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class OnboardingConfirmationViewController: UIViewController {
    // MARK: - Private variables
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let doneButton = HolkButton()
    
    private let insuranceIssuer: InsuranceIssuer
    
    // MARK: - Public variables
    weak var coordinator: OnboardingCoordinating?
    
    init(insuranceIssuer: InsuranceIssuer) {
        self.insuranceIssuer = insuranceIssuer
        
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
        navigationItem.title = "Start finding your gaps"
        
        imageView.image = UIImage(systemName: "checkmark.circle")?.withSymbolWeightConfiguration(.thin)
        imageView.tintColor = Color.successColor
        
        titleLabel.font = Font.bold(.header)
        titleLabel.textColor = Color.mainForegroundColor
        titleLabel.numberOfLines = 0
        titleLabel.text = "Great,"
        
        descriptionLabel.font = Font.regular(.caption)
        descriptionLabel.textColor = Color.mainForegroundColor
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = String(format: "We found your insurance at %@", insuranceIssuer.displayName)
        
        doneButton.setTitle("Add to Holk", for: .normal)
        doneButton.backgroundColor = Color.mainHighlightColor
        doneButton.titleLabel?.font = Font.semibold(.subtitle)
        doneButton.set(color: Color.mainForegroundColor)
        doneButton.addTarget(self, action: #selector(submit(_:)), for: .touchUpInside)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.lastBaselineAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            doneButton.heightAnchor.constraint(equalToConstant: 90),
            doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func submit(_ sender: UIButton) {
        coordinator?.finishOnboarding()
    }
}
