//
//  OnboardingInfoContainerViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2019-09-27.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

final class OnboardingInfoContainerViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private weak var OKButton: HolkButton!
    // MARK: - Public variables
    weak var coordinator: SessionCoordinator?
    // MARK: - Private variables
    private var pageViewController: UIViewController?
    
    override func viewDidLoad() {
        navigationItem.setHidesBackButton(true, animated: false)
        let backIcon = UIImage.fontAwesomeIcon(name: .chevronLeft, style: .regular, textColor: Color.mainForegroundColor, size: FontAwesome.mediumIconSize)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: backIcon, style: .plain, target: self, action: #selector(back(_:)))
        navigationController?.isNavigationBarHidden = false
        
        let pageViewController = StoryboardScene.Onboarding.onboardingInfoPageViewController.instantiate()
        self.pageViewController = pageViewController
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: OKButton.topAnchor)
        ])
        
        
        view.bringSubviewToFront(OKButton)
        OKButton.titleLabel?.font = Font.semibold(.caption)
        OKButton.setTitleColor(Color.mainForegroundColor, for: UIControl.State())
        OKButton.backgroundColor = Color.mainHighlightColor
        OKButton.addTarget(self, action: #selector(signup(_:)), for: .touchUpInside)
    }
    
    @objc private func back(_ sender: Any) {
        coordinator?.back()
    }
    
    @objc private func signup(_ sender: Any) {
        coordinator?.showSignup(presentByRoot: true)
    }
}
