//
//  LoginViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2019-04-30.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit
import RxSwift

final class LoginViewController: UIViewController {
    
    weak var coordinator: LoginCoordinator?
    
    private var bag = DisposeBag()
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func infoButtonTapped(_ sender: UIButton) {
        coordinator?.displayOnBoradingInfo()
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        APIStore.sharedInstance.login(username: "filip", password: "password").subscribe(onNext: { event in
            User.sharedInstance.accessToken = event.value?.access_token
            User.sharedInstance.refreshToken = event.value?.refresh_token
        }, onError: { error in
            
        }).disposed(by: bag)
    }
    
    @IBAction func signUpTapped(_ sender: UIButton) {
        if let window = UIApplication.shared.delegate?.window {
            window?.rootViewController = TabBarController()
        }
    }
    
    
}
