//
//  LandingViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2019-04-30.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit
import RxSwift

final class LandingViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var signupButton: UIButton!
    @IBOutlet private weak var onBoardingButton: UIButton!
    // MARK: - Public variables
    weak var coordinator: SessionCoordinator?
    // MARK: - Private variables
    private var bag = DisposeBag()
    
    override func viewDidLoad() {
        setup()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func infoButtonTapped(_ sender: UIButton) {
        coordinator?.displayOnboradingInfo()
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        coordinator?.showLogin()
    }
    
    @IBAction func signUpTapped(_ sender: UIButton) {
        coordinator?.showSignup()
    }
    
    private func setup() {
        view.backgroundColor = Color.landingBackgroundColor
        
        titleLabel.numberOfLines = 0
        titleLabel.textColor = Color.landingMainColor
        titleLabel.font = Font.extraBold(.header)
        loginButton.backgroundColor = Color.landingMainColor
        loginButton.titleLabel?.font = Font.semibold(.subtitle)
        loginButton.tintColor = Color.mainForegroundColor
        loginButton.setTitle("Logga in", for: UIControl.State())
        signupButton.layer.borderWidth = 1
        signupButton.layer.borderColor = Color.landingMainColor.cgColor
        signupButton.layer.cornerRadius = 7
        signupButton.titleLabel?.font = Font.semibold(.subtitle)
        signupButton.tintColor = Color.landingMainColor
        signupButton.setTitle("Skapa konto", for: UIControl.State())
        onBoardingButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        onBoardingButton.backgroundColor = Color.secondaryBackgroundColor
        onBoardingButton.layer.cornerRadius = 17.5
        onBoardingButton.titleLabel?.font = Font.semibold(.label)
        onBoardingButton.tintColor = Color.mainForegroundColor
    }
}
