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
    // MARK: - IBOutlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var emailTextField: HolkTextField!
    
    // MARK: - Public variables
    weak var coordinator: SessionCoordinator?
    
    // MARK: - Private variables
    private var textView = UITextView()
    private var doneButton = HolkButton()
    private var doneButtonBottomConstraint: NSLayoutConstraint!
    private var bag = DisposeBag()
    private var keyboardEventObserver: KeyboardEventObserver?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.setHidesBackButton(true, animated: animated)
    }
    
    private func setup() {        
        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark")?.withSymbolWeightConfiguration(.medium),
            style: .plain,
            target: self,
            action: #selector(backTapped(_:))
        )
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(_:)))
        view.addGestureRecognizer(tapGestureRecognizer)
        view.addSubview(textView)
        view.addSubview(doneButton)
        
        titleLabel.text = "Logga in"
        titleLabel.font = Font.extraBold(.subHeader)
        titleLabel.textColor = Color.mainHighlightTextColor
        subtitleLabel.text = "Ange en e-post adress och ett valfritt lösenord."
        subtitleLabel.font = Font.light(.subtitle)
        subtitleLabel.textColor = Color.mainForegroundColor
        
        emailTextField.helpColor = Color.placeHolderColor
        emailTextField.placeholder = "E-post adress"
        emailTextField.textColor = Color.mainForegroundColor
        emailTextField.tintColor = Color.mainForegroundColor
        emailTextField.placeholderTextColor = Color.placeHolderColor
        
        // TODO: Replace the google link to an actual change password page
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.attributedText = Parser.parse(
            markdownString: "[Har du glömt ditt lösenord?](https://www.google.com)",
            font: Font.semibold(.body),
            textColor: Color.mainForegroundColor
        )
        // Seems there is an issue with the library for parsing
        textView.linkTextAttributes = [
            .foregroundColor: Color.mainHighlightTextColor
        ]
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.isEditable = false
        
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButtonBottomConstraint = view.bottomAnchor.constraint(equalTo: doneButton.bottomAnchor)
        doneButton.setTitle("Logga in", for: .normal)
        doneButton.backgroundColor = Color.mainHighlightColor
        doneButton.titleLabel?.font = Font.semibold(.subtitle)
        doneButton.set(color: Color.mainForegroundColor)
        doneButton.addTarget(self, action: #selector(submit(_:)), for: .touchUpInside)
        emailTextField.rx.text.orEmpty.map{ $0.isEmpty }.bind(to: doneButton.rx.isHidden).disposed(by: bag)
        
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 45),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -45),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
            
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            doneButton.heightAnchor.constraint(equalToConstant: 90),
            doneButtonBottomConstraint
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
