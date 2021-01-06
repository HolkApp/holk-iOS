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

    private let tableView = UITableView()

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

        tableView.backgroundColor = Color.mainBackground
        tableView.separatorStyle = .none
//        tableView.register(ProfileSectionHeaderView.self,
//                    forHeaderFooterViewReuseIdentifier: ProfileSectionHeaderView.identifier)
//
//        tableView.register(ProfileTitleTableViewCell.self, forCellReuseIdentifier: ProfileTitleTableViewCell.identifier)
//        tableView.register(ProfileMultiRowTableViewCell.self, forCellReuseIdentifier: ProfileMultiRowTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc private func logout() {
        delegate?.logout(self)
    }

    @objc private func deleteUser() {
        delegate?.delete(self)
    }
}
