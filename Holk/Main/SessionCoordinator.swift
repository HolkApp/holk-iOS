//
//  SessionCoordinator.swift
//  Holk
//
//  Created by 张梦皓 on 2019-10-13.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

final class SessionCoordinator: NSObject, UINavigationControllerDelegate {
    // MARK: - Public Properties
    weak var coordinator: ShellCoordinator?

    // MARK: - Private Properties
    private var presenterViewController: UIViewController
    private var storeController: StoreController
    
    // MARK: - Init
    init(presenterViewController: UIViewController, storeController: StoreController) {
        self.presenterViewController = presenterViewController
        self.storeController = storeController
        
        super.init()
    }
    
    func start() {
        showSession()
    }

    func logout() {
        coordinator?.logout()
    }

    private func showSession() {
        let tabbarController = TabBarController(storeController: storeController)
        tabbarController.navigationItem.hidesBackButton = true
        tabbarController.coordinator = self
        tabbarController.modalPresentationStyle = .overFullScreen
        presenterViewController.present(tabbarController, animated: false)
    }
}
