//
//  OnboardingSignupViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2019-04-24.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

class OnboardingSignupViewController: UIViewController {

    weak var coordinator: OnboardingCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = false
        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "RoundedClose").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(backTapped(_:)))
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.setHidesBackButton(true, animated: animated)
    }
    
    @objc private func backTapped(_ sender: UIButton) {
        coordinator?.back()
    }


}

