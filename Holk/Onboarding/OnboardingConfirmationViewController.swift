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
    private let cardView = UIView()
    private let cardContentView = UIView()
    private let insuranceLabel = UILabel()
    private let addressLabel = UILabel()
    private let badgeLabel = UILabel()
    private let doneButton = HolkButton()
    
    var addedInsurance: Insurance? {
        didSet {
            DispatchQueue.main.async {
                self.descriptionLabel.text = String(format: "We found your insurance at %@", self.addedInsurance?.insuranceProvider.displayName ?? "")
                self.insuranceLabel.text = self.addedInsurance?.insuranceType
                self.addressLabel.text = self.addedInsurance?.address
            }
        }
    }
    
    // MARK: - Public variables
    weak var coordinator: OnboardingCoordinating?
    
    init() {
        
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
        navigationItem.hidesBackButton = true
        
        imageView.image = UIImage(systemName: "checkmark.circle")?.withSymbolWeightConfiguration(.thin)
        imageView.tintColor = Color.successColor
        
        titleLabel.font = Font.bold(.header)
        titleLabel.textColor = Color.mainForegroundColor
        titleLabel.numberOfLines = 0
        titleLabel.text = "Great,"
        
        descriptionLabel.font = Font.regular(.title)
        descriptionLabel.textColor = Color.mainForegroundColor
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = String(format: "We found your insurance at %@", addedInsurance?.insuranceProvider.displayName ?? "")
        
        cardView.backgroundColor = .clear
        cardView.layoutMargins = .init(top: 16, left: 32, bottom: 16, right: 32)
        
        cardContentView.backgroundColor = Color.mainBackgroundColor
        cardContentView.layer.shadowRadius = 15
        cardContentView.layer.shadowOffset = CGSize(width: 0, height: 8)
        cardContentView.layer.shadowColor = UIColor.black.cgColor
        cardContentView.layer.shadowOpacity = 0.08
        
        insuranceLabel.font = Font.semiBold(.title)
        insuranceLabel.textColor = Color.mainForegroundColor
        insuranceLabel.numberOfLines = 0
        insuranceLabel.text = addedInsurance?.insuranceType
        
        addressLabel.font = Font.regular(.label)
        addressLabel.textColor = Color.mainForegroundColor
        addressLabel.numberOfLines = 0
        addressLabel.text = addedInsurance?.address
        
        badgeLabel.font = Font.regular(.label)
        badgeLabel.textAlignment = .center
        badgeLabel.textColor = Color.mainBackgroundColor
        badgeLabel.layer.cornerRadius = 16
        badgeLabel.layer.backgroundColor = UIColor.red.cgColor
        badgeLabel.text = "7"
        
        doneButton.setTitle("Add to Holk", for: .normal)
        doneButton.backgroundColor = Color.mainHighlightColor
        doneButton.titleLabel?.font = Font.semiBold(.subtitle)
        doneButton.set(color: Color.mainForegroundColor)
        doneButton.addTarget(self, action: #selector(submit(_:)), for: .touchUpInside)
        
        setupLayout()
    }
    
    private func setupLayout() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardContentView.translatesAutoresizingMaskIntoConstraints = false
        insuranceLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        badgeLabel.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(cardView)
        cardView.addSubview(cardContentView)
        cardContentView.addSubview(insuranceLabel)
        cardContentView.addSubview(addressLabel)
        cardView.addSubview(badgeLabel)
        view.addSubview(doneButton)
        
        let cardViewBottomConstraint = cardView.bottomAnchor.constraint(lessThanOrEqualTo: doneButton.topAnchor)
            cardViewBottomConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.lastBaselineAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            cardView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cardViewBottomConstraint,
            
            cardContentView.leadingAnchor.constraint(equalTo: cardView.layoutMarginsGuide.leadingAnchor),
            cardContentView.topAnchor.constraint(equalTo: cardView.layoutMarginsGuide.topAnchor),
            cardContentView.trailingAnchor.constraint(equalTo: cardView.layoutMarginsGuide.trailingAnchor),
            cardContentView.bottomAnchor.constraint(equalTo: cardView.layoutMarginsGuide.bottomAnchor),
            
            insuranceLabel.leadingAnchor.constraint(equalTo: cardContentView.leadingAnchor, constant: 24),
            insuranceLabel.topAnchor.constraint(equalTo: cardContentView.topAnchor, constant: 24),
            insuranceLabel.trailingAnchor.constraint(equalTo: cardContentView.trailingAnchor, constant: -24),
            
            addressLabel.leadingAnchor.constraint(equalTo: cardContentView.leadingAnchor, constant: 24),
            addressLabel.topAnchor.constraint(equalTo: insuranceLabel.lastBaselineAnchor, constant: 8),
            addressLabel.trailingAnchor.constraint(equalTo: cardContentView.trailingAnchor, constant: -24),
            addressLabel.lastBaselineAnchor.constraint(equalTo: cardContentView.bottomAnchor, constant: -32),
            
            badgeLabel.widthAnchor.constraint(equalToConstant: 32),
            badgeLabel.heightAnchor.constraint(equalToConstant: 32),
            badgeLabel.centerYAnchor.constraint(equalTo: cardContentView.topAnchor),
            badgeLabel.trailingAnchor.constraint(equalTo: cardContentView.trailingAnchor, constant: -40),
            
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
