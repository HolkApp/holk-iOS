//
//  SignupViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2019-04-24.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SignupViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var emailTextField: HolkTextField!
    @IBOutlet private weak var passwordTextField: HolkTextField!
    // MARK: - Public variables
    var storeController: StoreController?
    weak var coordinator: SessionCoordinator?
    // MARK: - Private variables
    private let existAccountButton = UIButton()
    private let infoTextView = UITextView()
    private let doneButton = HolkButton()
    private var doneButtonBottomConstraint: NSLayoutConstraint!
    private var bag = DisposeBag()
    private var keyboardEventObserver: KeyboardEventObserver?
    
    // MARK: - Overridden methods
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
        let closeIcon = UIImage.fontAwesomeIcon(name: .times, style: .light, textColor: Color.mainForegroundColor, size: FontAwesome.mediumIconSize)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: closeIcon, style: .plain, target: self, action: #selector(backTapped(_:)))
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(_:)))
        view.addGestureRecognizer(tapGestureRecognizer)
        view.addSubview(existAccountButton)
        view.addSubview(infoTextView)
        view.addSubview(doneButton)
        
        titleLabel.text = "Skapa användare"
        titleLabel.font = Font.extraBold(.subHeader)
        titleLabel.textColor = Color.mainForegroundColor
        subtitleLabel.text = "Ange en e-post adress och ett valfritt lösenord."
        subtitleLabel.font = Font.light(.subtitle)
        subtitleLabel.textColor = Color.mainForegroundColor
        
        emailTextField.helpColor = Color.placeHolderTextColor
        emailTextField.placeholder = "E-post adress"
        emailTextField.textColor = Color.mainForegroundColor
        emailTextField.tintColor = Color.mainForegroundColor
        emailTextField.placeholderTextColor = Color.placeHolderTextColor
        passwordTextField.helpColor = Color.placeHolderTextColor
        passwordTextField.textColor = Color.mainForegroundColor
        passwordTextField.tintColor = Color.mainForegroundColor
        passwordTextField.placeholder = "Ange ett lösenord"
        passwordTextField.placeholderTextColor = Color.placeHolderTextColor
        passwordTextField.isSecureTextEntry = true
        
        existAccountButton.translatesAutoresizingMaskIntoConstraints = false
        existAccountButton.contentHorizontalAlignment = .leading
        existAccountButton.setTitle("Already has an account? Click here", for: .normal)
        existAccountButton.setTitleColor(Color.mainHighlightColor, for: UIControl.State())
        existAccountButton.titleLabel?.font = Font.bold(.label)
        existAccountButton.addTarget(self, action: #selector(existedAccount(_:)), for: .touchUpInside)
        
        infoTextView.translatesAutoresizingMaskIntoConstraints = false
        infoTextView.textColor = Color.mainForegroundColor
        infoTextView.font = Font.regular(.description)
        infoTextView.text = "Genom att skapa ett konto godkänner du användarvilkoren."
        infoTextView.isScrollEnabled = false
        infoTextView.backgroundColor = .clear
        infoTextView.isEditable = false
        
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButtonBottomConstraint = view.bottomAnchor.constraint(equalTo: doneButton.bottomAnchor, constant: 0)
        doneButton.setTitle("Skapa konot", for: UIControl.State())
        doneButton.backgroundColor = Color.mainHighlightColor
        doneButton.titleLabel?.font = Font.semibold(.subtitle)
        doneButton.tintColor = Color.mainForegroundColor
        doneButton.setTitleColor(Color.mainForegroundColor, for: UIControl.State())
        doneButton.addTarget(self, action: #selector(submit(_:)), for: .touchUpInside)

        Observable.combineLatest(emailTextField.rx.text, passwordTextField.rx.text) { (emailText, passwordText) -> Bool in
            guard let emailText = emailText, let passwordText = passwordText else {
                return false
            }
            return emailText.isEmpty || passwordText.isEmpty
        }
        .bind(to: doneButton.rx.isHidden)
        .disposed(by: bag)
        
        NSLayoutConstraint.activate([
            existAccountButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            existAccountButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            existAccountButton.bottomAnchor.constraint(equalTo: infoTextView.topAnchor),
            infoTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 45),
            infoTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -45),
            infoTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
            
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
    
    @objc private func existedAccount(_ sender: UIButton) {
        coordinator?.showLogin(presentByRoot: true)
        hideKeyboard(sender)
    }
    
    @objc private func hideKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
    @objc private func submit(_ sender: UIButton) {
        signup()
        hideKeyboard(sender)
    }
    
    private func signup() {
        if let username = emailTextField.text,
            let password = passwordTextField.text,
            let storeController = storeController {
            storeController.authenticationStore
                .signup(username: username, password: password)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { [weak self] event in
                    switch event {
                    case .success:
                        self?.coordinator?.onboarding()
                    case .failure(let error):
                        // TODO: Error handling
                        print(error)
                        self?.coordinator?.onboarding()
                    }
                }, onError: { error in
                    // TODO: Network error handling
                    print(error)
                }).disposed(by: bag)
        }
    }
}
