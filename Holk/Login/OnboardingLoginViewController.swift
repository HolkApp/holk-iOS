//
//  OnboardingLoginViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2019-08-28.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class OnboardingLoginViewController: UIViewController {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var emailTextField: HolkTextField!
    @IBOutlet private weak var passwordTextField: HolkTextField!
    
    private var textView = UITextView()
    private var doneButton = HolkButton()
    private var doneButtonBottomConstraint: NSLayoutConstraint!
    private var bag = DisposeBag()
    private var keyboardEventObserver: KeyboardEventObserver?
    
    weak var coordinator: OnboardingCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.setHidesBackButton(true, animated: animated)
    }
    
    private func setup() {
        navigationController?.isNavigationBarHidden = false
        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "RoundedClose").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(backTapped(_:)))
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(_:)))
        view.addGestureRecognizer(tapGestureRecognizer)
        view.addSubview(textView)
        view.addSubview(doneButton)
        
        titleLabel.text = "Logga in"
        titleLabel.font = Font.extraBold(.secondHeader)
        subtitleLabel.text = "Ange en e-post adress och ett valfritt lösenord."
        subtitleLabel.font = Font.light(.subtitle)
        
        emailTextField.helpColor = Color.placeHolderTextColor
        emailTextField.placeholder = "E-post adress"
        emailTextField.tintColor = Color.mainForegroundColor
        emailTextField.placeholderTextColor = Color.placeHolderTextColor
        passwordTextField.helpColor = Color.placeHolderTextColor
        passwordTextField.tintColor = Color.mainForegroundColor
        passwordTextField.placeholder = "Ange ett lösenord"
        passwordTextField.placeholderTextColor = Color.placeHolderTextColor
        passwordTextField.isSecureTextEntry = true
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = Color.mainForegroundColor
        textView.font = Font.regular(.description)
        textView.text = "Genom att skapa ett konto godkänner du användarvilkoren."
        textView.isScrollEnabled = false
        
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButtonBottomConstraint = view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: doneButton.bottomAnchor, constant: 0)
        doneButton.setTitle("Logga in", for: UIControl.State())
        doneButton.backgroundColor = Color.mainButtonBackgroundColor
        doneButton.titleLabel?.font = Font.semibold(.subtitle)
        doneButton.tintColor = Color.mainForegroundColor
        doneButton.setTitleColor(Color.mainForegroundColor, for: UIControl.State())
        doneButton.addTarget(self, action: #selector(submit(_:)), for: .touchUpInside)
        
        Observable.combineLatest(emailTextField.rx.text, passwordTextField.rx.text) { (emailText, passwordText) -> Bool in
            guard let emailText = emailText, let passwordText = passwordText else {
                return false
            }
            return !emailText.isEmpty && !passwordText.isEmpty
            }.bind(to: doneButton.rx.isEnabled).disposed(by: bag)
        
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 45),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -45),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
            
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            doneButton.heightAnchor.constraint(equalToConstant: 80),
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
        if let window = UIApplication.shared.delegate?.window {
            window?.rootViewController = TabBarController()
        }
    }
}
