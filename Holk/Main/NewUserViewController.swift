//
//  LoginViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2019-08-28.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit
import Combine

protocol NewUserViewControllerDelegate: AnyObject {
    func newUserViewController(_ viewController: NewUserViewController, add email: String)
}

class NewUserViewController: UIViewController {
    // MARK: - Public variables
    weak var delegate: NewUserViewControllerDelegate?
    
    // MARK: - Private variables
    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let emailTextField = HolkTextField()
    private var doneButton = HolkButton()
    private var doneButtonBottomConstraint: NSLayoutConstraint!
    private var keyboardEventObserver: KeyboardEventObserver?
    private var user: User
    private var cancellables = Set<AnyCancellable>()
    
    init(user: User) {
        self.user = user
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
        view.layoutMargins = .init(top: 20, left: 40, bottom: 20, right: 40)
        view.backgroundColor = Color.mainBackgroundColor
        
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
        
        titleLabel.text = "Hi \(user.givenName),"
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
        descriptionLabel.font = Font.regular(.subtitle)
        descriptionLabel.textColor = Color.mainForegroundColor
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        emailTextField.helpColor = Color.placeHolderColor
        emailTextField.placeholder = "E-post adress"
        emailTextField.textColor = Color.mainForegroundColor
        emailTextField.tintColor = Color.mainForegroundColor
        emailTextField.returnKeyType = .continue
        emailTextField.delegate = self
        emailTextField.placeholderTextColor = Color.placeHolderColor
        
        doneButton.contentVerticalAlignment = .fill
        doneButton.contentHorizontalAlignment = .fill
        doneButton.set(
            color: Color.mainForegroundColor,
            image: UIImage(systemName: "arrow.right.circle")?.withSymbolWeightConfiguration(.ultraLight)
        )
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.isHidden = true
        doneButton.addTarget(self, action: #selector(submit(_:)), for: .touchUpInside)

        emailTextField.textPublisher
            .compactMap({ !EmailValidation.isValid($0) })
            .assign(to: \.isHidden, on: doneButton)
            .store(in: &cancellables)
        
        doneButtonBottomConstraint = view.bottomAnchor.constraint(equalTo: doneButton.bottomAnchor, constant: 40)
        let stackViewTopConstraint = stackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20)
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
    
    @objc private func hideKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
    @objc private func submit(_ sender: UIButton) {
        addEmail()
        hideKeyboard(sender)
    }
    
    private func addEmail() {
        if let email = emailTextField.text {
            delegate?.newUserViewController(self, add: email)
        }
    }
}

extension NewUserViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        if let text = textField.text, EmailValidation.isValid(text) {
            addEmail()
        }
        return true
    }
}
