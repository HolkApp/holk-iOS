//
//  LoginViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2019-08-28.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class NewUserViewController: UIViewController {
    // MARK: - Public variables
    weak var coordinator: SessionCoordinator?
    
    // MARK: - Private variables
    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let emailTextField = HolkTextField()
    private var doneButton = HolkButton()
    private var doneButtonBottomConstraint: NSLayoutConstraint!
    private var bag = DisposeBag()
    private var keyboardEventObserver: KeyboardEventObserver?
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.setHidesBackButton(true, animated: animated)
    }
    
    private func setup() {
        view.layoutMargins = .init(top: 20, left: 40, bottom: 20, right: 40)
        view.backgroundColor = Color.mainBackgroundColor
        
        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark")?.withSymbolWeightConfiguration(.medium),
            style: .plain,
            target: self,
            action: #selector(backTapped(_:))
        )
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(_:)))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.setCustomSpacing(16, after: titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        stackView.setCustomSpacing(24, after: subtitleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.setCustomSpacing(32, after: descriptionLabel)
        stackView.addArrangedSubview(emailTextField)
        view.addSubview(doneButton)
        
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = "Hi Peter,"
        titleLabel.font = Font.extraBold(.header)
        titleLabel.textColor = Color.mainForegroundColor
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        subtitleLabel.text = "Great to see that you want to sign up for Holk"
        subtitleLabel.font = Font.regular(.title)
        subtitleLabel.textColor = Color.mainForegroundColor
        subtitleLabel.numberOfLines = 0
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionLabel.text = "Enter your mail adress in order to complete your account"
        descriptionLabel.font = Font.light(.subtitle)
        descriptionLabel.textColor = Color.mainForegroundColor
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        emailTextField.helpColor = Color.placeHolderColor
        emailTextField.placeholder = "E-post adress"
        emailTextField.textColor = Color.mainForegroundColor
        emailTextField.tintColor = Color.mainForegroundColor
        emailTextField.placeholderTextColor = Color.placeHolderColor
        
        doneButton.contentVerticalAlignment = .fill
        doneButton.contentHorizontalAlignment = .fill
        doneButton.set(
            color: Color.mainForegroundColor,
            image: UIImage(systemName: "arrow.right.circle")?.withSymbolWeightConfiguration(.ultraLight)
        )
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.addTarget(self, action: #selector(submit(_:)), for: .touchUpInside)
        emailTextField.rx.text.orEmpty.map{ !$0.isEmpty }.bind(to: doneButton.rx.isEnabled).disposed(by: bag)
        
        doneButtonBottomConstraint = view.bottomAnchor.constraint(equalTo: doneButton.bottomAnchor, constant: 40)
        let stackViewTopConstraint = stackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor)
        stackViewTopConstraint.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stackViewTopConstraint,
            stackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            doneButton.topAnchor.constraint(greaterThanOrEqualTo: stackView.bottomAnchor, constant: 24),
            doneButtonBottomConstraint,
            doneButton.widthAnchor.constraint(equalToConstant: 80),
            doneButton.heightAnchor.constraint(equalToConstant: 80),
            doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ])
        let keyboardEventFloatingViewHandler = KeyboardEventFloatingViewHandler(floatingView: doneButton, view: view, bottomConstraint: doneButtonBottomConstraint)
        keyboardEventObserver = KeyboardEventObserver(handler: keyboardEventFloatingViewHandler)
    }
    
    @objc private func backTapped(_ sender: UIButton) {
        coordinator?.back()
    }
    
    @objc private func hideKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
    @objc private func submit(_ sender: UIButton) {
        addEmail()
        hideKeyboard(sender)
    }
    
    private func addEmail() {
        if let username = emailTextField.text {
            coordinator?.startOnboarding(username)
        }
    }
}
