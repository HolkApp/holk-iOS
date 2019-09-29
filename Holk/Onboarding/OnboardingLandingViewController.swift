//
//  OnboardingLandingViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2019-04-30.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit
import RxSwift

final class OnboardingLandingViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var signupButton: UIButton!
    @IBOutlet private weak var onBoardingButton: UIButton!
    // MARK: - Public variables
    weak var coordinator: OnboardingCoordinator?
    // MARK: - Private variables
    private var bag = DisposeBag()
    
    override func viewDidLoad() {
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func infoButtonTapped(_ sender: UIButton) {
        coordinator?.displayOnBoradingInfo()
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        // TODO: login
        coordinator?.login()
    }
    
    @IBAction func signUpTapped(_ sender: UIButton) {
        coordinator?.signup()
    }
    
    private func setup() {
        view.backgroundColor = Color.onBoardingBackgroundColor
        
        titleLabel.numberOfLines = 0
        titleLabel.tintColor = Color.mainForegroundColor
        titleLabel.font = Font.extraBold(.header)
        loginButton.backgroundColor = Color.mainHighlightColor
        loginButton.titleLabel?.font = Font.semibold(.subtitle)
        loginButton.tintColor = Color.mainForegroundColor
        loginButton.setTitle("Logga in", for: UIControl.State())
        signupButton.layer.borderWidth = 1
        signupButton.layer.borderColor = Color.mainForegroundColor.cgColor
        signupButton.layer.cornerRadius = 7
        signupButton.titleLabel?.font = Font.semibold(.subtitle)
        signupButton.tintColor = Color.mainForegroundColor
        signupButton.setTitle("Skapa konto", for: UIControl.State())
        onBoardingButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        onBoardingButton.backgroundColor = Color.secondaryBackgroundColor
        onBoardingButton.layer.cornerRadius = 17.5
        onBoardingButton.titleLabel?.font = Font.semibold(.description)
        onBoardingButton.tintColor = Color.mainForegroundColor
    }
    
    private func loginRequest() {
        APIStore.sharedInstance.login(username: "filip", password: "password")
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { event in
                switch event {
                case .success(let value):
                    User.sharedInstance.accessToken = value.accessToken
                    User.sharedInstance.refreshToken = value.refreshToken
                case .failure(let error):
                    print("server error here")
                    print(error)
                }
            }, onError: { error in
                print("network error here")
            }).disposed(by: bag)
    }
    
}
