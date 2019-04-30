//
//  MainCoordinator.swift
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

class MainCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    // MARK: - Public Properties
    var navController: UINavigationController
    
    // MARK: - Init
    init(navController: UINavigationController) {
        self.navController = navController
    }
    
    // MARK: - Public Methods
    func start() {
        let vc = StoryboardScene.Main.landingViewController.instantiate()
        vc.coordinator = self
        navController.tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 0)
        navController.isNavigationBarHidden = true
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
