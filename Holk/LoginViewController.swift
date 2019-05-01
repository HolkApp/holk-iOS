//
//  LoginViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2019-04-30.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    weak var coordinator: LoginCoordinator?
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func infoButtonTapped(_ sender: UIButton) {
        coordinator?.displayOnBoradingInfo()
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func signUpTapped(_ sender: UIButton) {
        if let window = UIApplication.shared.delegate?.window {
            window?.rootViewController = TabBarController()
        }
    }
    
    
}
