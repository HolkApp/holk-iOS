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
    private weak var presenterViewController: UIViewController?
    private var storeController: StoreController
    
    // MARK: - Init
    init(presenterViewController: UIViewController, storeController: StoreController) {
        self.presenterViewController = presenterViewController
        self.storeController = storeController
        
        super.init()
    }
    
    func start() {
        DispatchQueue.main.async {
            let tabbarController = TabBarController(storeController: self.storeController)
            tabbarController.navigationItem.hidesBackButton = true
            tabbarController.coordinator = self
            tabbarController.modalPresentationStyle = .fullScreen
            self.presenterViewController?.present(tabbarController, animated: false)
        }
    }

    func logout() {
        coordinator?.logout()
    }

    func deleteAccount() {
        storeController.userStore.delete { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.coordinator?.logout()
            case .failure(let error):
                // TODO: Error handling
                print(error)
            }
        }
    }
}
