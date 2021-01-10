//
//  AddInsuranceConfirmationViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2020-05-04.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class AddInsuranceConfirmationViewController: UIViewController {
    // MARK: - Private variables
    private let storeController: StoreController

    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let cardView = UIView()
    private let cardContentView = UIView()
    private let insuranceLabel = UILabel()
    private let addressLabel = UILabel()
    private let badgeLabel = UILabel()
    private var addedInsurance: Insurance? {
        didSet {
            DispatchQueue.main.async {
                guard let addedInsurance = self.addedInsurance, let insuranceProvider = self.storeController.providerStore[addedInsurance.insuranceProviderName] else { return }
                self.descriptionLabel.text = String(format: LocalizedString.Insurance.Aggregate.Confirmation.insuranceFound, insuranceProvider.displayName)
                self.insuranceLabel.text = addedInsurance.kind.description
                self.addressLabel.text = addedInsurance.address
            }
        }
    }

    init(_ storeController: StoreController, addedInsuranceList: [Insurance]) {
        self.storeController = storeController
        self.addedInsurance = addedInsuranceList.first

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
        navigationItem.title = LocalizedString.Insurance.Aggregate.navigationTitle
        navigationItem.hidesBackButton = true

        imageView.image = UIImage(systemName: "checkmark.circle")?.withSymbolWeightConfiguration(.light)
        imageView.tintColor = Color.success

        titleLabel.font = FontStyleGuide.header2.font
        titleLabel.textColor = Color.mainForeground
        titleLabel.numberOfLines = 0
        titleLabel.text = "Great,"

        descriptionLabel.font = Font.regular(.title)
        descriptionLabel.textColor = Color.mainForeground
        descriptionLabel.numberOfLines = 0
        if let addedInsurance = addedInsurance,
            let provider = storeController.providerStore[addedInsurance.insuranceProviderName] {
            descriptionLabel.text = String(format: LocalizedString.Insurance.Aggregate.Confirmation.insuranceFound, provider.displayName)
        } else {
            descriptionLabel.text = LocalizedString.Insurance.Aggregate.Confirmation.insuranceNotFound

        }

        cardView.backgroundColor = .clear
        cardView.layoutMargins = .init(top: 16, left: 32, bottom: 16, right: 32)

        cardContentView.backgroundColor = Color.mainBackground
        cardContentView.layer.shadowRadius = 15
        cardContentView.layer.shadowOffset = CGSize(width: 0, height: 4)
        cardContentView.layer.shadowColor = UIColor.black.cgColor
        cardContentView.layer.shadowOpacity = 0.08

        insuranceLabel.font = Font.semiBold(.title)
        insuranceLabel.textColor = Color.mainForeground
        insuranceLabel.numberOfLines = 0
        insuranceLabel.text = addedInsurance?.kind.description

        addressLabel.font = Font.regular(.label)
        addressLabel.textColor = Color.mainForeground
        addressLabel.numberOfLines = 0
        addressLabel.text = addedInsurance?.address

        badgeLabel.font = Font.regular(.label)
        badgeLabel.textAlignment = .center
        badgeLabel.textColor = Color.mainBackground
        badgeLabel.layer.cornerRadius = 16
        badgeLabel.layer.backgroundColor = UIColor.red.cgColor
        badgeLabel.text = "7"

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

        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(cardView)
        cardView.addSubview(cardContentView)
        cardContentView.addSubview(insuranceLabel)
        cardContentView.addSubview(addressLabel)
        cardView.addSubview(badgeLabel)

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
            cardView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -90).withPriority(.defaultHigh),

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
            badgeLabel.trailingAnchor.constraint(equalTo: cardContentView.trailingAnchor, constant: -40)
        ])
    }
}

