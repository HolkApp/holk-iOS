//
//  OnboardingSignupViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2019-04-24.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

class OnboardingSignupViewController: UIViewController {

    @IBOutlet private weak var emailTextField: HolkTextField!
    @IBOutlet private weak var passwordTextField: HolkTextField!
    
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
        
        emailTextField.helpColor = Color.placeHolderTextColor
        emailTextField.placeholder = "E-post adress"
        emailTextField.tintColor = Color.mainForegroundColor
        emailTextField.placeholderTextColor = Color.placeHolderTextColor
        passwordTextField.helpColor = Color.placeHolderTextColor
        passwordTextField.tintColor = Color.mainForegroundColor
        passwordTextField.placeholder = "Ange ett lösenord"
        passwordTextField.placeholderTextColor = Color.placeHolderTextColor
    }
    
    @objc private func backTapped(_ sender: UIButton) {
        coordinator?.back()
    }


}

