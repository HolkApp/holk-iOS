//
//  OnboardingConsentViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2020-02-12.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit
import MarkdownKit

protocol OnboardingConsentViewControllerDelegate: AnyObject {
    func aggregateInsurance(_ insuranceProvider: InsuranceProvider)
}

final class OnboardingConsentViewController: UIViewController {
    // MARK: - Public variables
    weak var delegate: OnboardingConsentViewControllerDelegate?
    
    // MARK: - Private variables
    private var storeController: StoreController
    private let insuranceProvider: InsuranceProvider
    private let headerLabel = UILabel()
    private let descriptionTextView = UITextView()
    private let bankIDIconView = UIImageView()
    private let nextButton = HolkButton()
    
    init(storeController: StoreController, insuranceProvider: InsuranceProvider) {
        self.storeController = storeController
        self.insuranceProvider = insuranceProvider
        
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
        
        view.layoutMargins.left = 40
        view.layoutMargins.right = 40
        view.backgroundColor = Color.mainBackgroundColor
        
        headerLabel.font = Font.bold(.header)
        headerLabel.textColor = Color.mainForegroundColor
        headerLabel.textAlignment = .left
        headerLabel.text = "Add your insurance"
        headerLabel.numberOfLines = 0

        descriptionTextView.backgroundColor = .clear
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.isEditable = false
        descriptionTextView.linkTextAttributes = [
            .foregroundColor: Color.landingBackgroundColor,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let text = "We will fetch your insurance from %@. \n[Our terms and policies](http://google.com)"
        let descriptionText = String(format: text, insuranceProvider.displayName)
        descriptionTextView.attributedText = Parser.parse(
            markdownString: descriptionText,
            font: Font.regular(.label),
            textColor: Color.mainForegroundColor
        )
        
        bankIDIconView.image = UIImage(named: "BankID")
        bankIDIconView.backgroundColor = .clear
        
        nextButton.contentVerticalAlignment = .fill
        nextButton.contentHorizontalAlignment = .fill
        nextButton.set(
            color: Color.mainForegroundColor,
            image: UIImage(systemName: "arrow.right.circle")?.withSymbolWeightConfiguration(.ultraLight)
        )
        nextButton.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
        
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(headerLabel)
        view.addSubview(descriptionTextView)
        view.addSubview(bankIDIconView)
        view.addSubview(nextButton)
        
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        bankIDIconView.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            headerLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            descriptionTextView.topAnchor.constraint(equalTo: headerLabel.lastBaselineAnchor, constant: 40),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            bankIDIconView.widthAnchor.constraint(equalToConstant: 80),
            bankIDIconView.heightAnchor.constraint(equalToConstant: 80),
            bankIDIconView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bankIDIconView.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -36),
            
            nextButton.widthAnchor.constraint(equalToConstant: 80),
            nextButton.heightAnchor.constraint(equalToConstant: 80),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
        ])
    }
    
    @objc private func nextButtonTapped(_ sender: UIButton) {
        delegate?.aggregateInsurance(insuranceProvider)
    }
}
