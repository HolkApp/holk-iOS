//
//  ProfileViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2021-01-03.
//  Copyright © 2021 Holk. All rights reserved.
//

import UIKit

protocol ProfileViewControllerdelegate: AnyObject {
    func logout(_ profileViewController: ProfileViewController)
    func delete(_ profileViewController: ProfileViewController)
}

final class ProfileViewController: UIViewController {
    weak var delegate: ProfileViewControllerdelegate?

    private let imageView = UIImageView()
    private let nameLabel = HolkLabel()
    private let logoutButton = HolkButton()
    private let deleteAccountButton = HolkButton()

    private var storeController: StoreController

    init(storeController: StoreController) {
        self.storeController = storeController

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    private func setup() {
        view.layoutMargins = .init(top: 0, left: 20, bottom: 16, right: 20)
        view.backgroundColor = Color.mainBackground

        imageView.image = UIImage(systemName: "person.circle")
        imageView.translatesAutoresizingMaskIntoConstraints = false

        nameLabel.text = storeController.user.userName
        nameLabel.textAlignment = .center
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        logoutButton.setTitle(LocalizedString.Generic.logout, for: .normal)
        logoutButton.set(color: Color.label)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false

        deleteAccountButton.addTarget(self, action: #selector(deleteUser), for: .touchUpInside)
        deleteAccountButton.setTitle(LocalizedString.Generic.deleteAccount, for: .normal)
        deleteAccountButton.set(color: Color.label)
        deleteAccountButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(imageView)
        view.addSubview(nameLabel)
        view.addSubview(logoutButton)
        view.addSubview(deleteAccountButton)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 60),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            imageView.heightAnchor.constraint(equalToConstant: 50),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),

            deleteAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            logoutButton.topAnchor.constraint(equalTo: deleteAccountButton.bottomAnchor, constant: 16),
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
    }

    @objc private func logout() {
        delegate?.logout(self)
    }

    @objc private func deleteUser() {
        delegate?.delete(self)
    }
}
