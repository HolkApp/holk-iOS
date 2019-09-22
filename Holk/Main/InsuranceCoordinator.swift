//
//  InsuranceCoordinator.swift
//  Holk
//
//  Created by 张梦皓 on 2019-04-29.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

protocol Coordinator {
    var navController: UINavigationController { get set }
    func start()
}

class InsuranceCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    // MARK: - Public Properties
    var navController: UINavigationController
    
    // MARK: - Init
    init(navController: UINavigationController) {
        self.navController = navController
    }
    
    // MARK: - Public Methods
    func start() {
        // TODO: Should present the landing page
//        let vc = StoryboardScene.MaOnboardingin.landingViewController.instantiate()
//        vc.tabBarItem = UITabBarItem(title: "Översikt", image: UIImage(named: "OverView"), tag: 0)
//        vc.coordinator = self
        
        let vc = StoryboardScene.InsuranceOverview.insuranceOverviewViewController.instantiate()
        let tabBarIcon = UIImage.fontAwesomeIcon(name: .clipboardList, style: .light, textColor: .systemBlue, size: Font.tabBarIconSize)
        navController.tabBarItem = UITabBarItem(title: "Översikt", image: tabBarIcon, tag: 0)
        navController.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navController.navigationBar.shadowImage = UIImage()
        navController.navigationBar.tintColor = .black
        navController.delegate = self
        navController.pushViewController(vc, animated: true)
    }
    
    
    // MARK: - UINavigationControllerDelegate
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
        // check the fromVC if it is a sepecific VC then handle the navigation back action if needed
        
    }
}
