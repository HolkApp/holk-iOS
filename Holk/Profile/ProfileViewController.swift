//
//  ProfileViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2021-01-03.
//  Copyright © 2021 Holk. All rights reserved.
//

import UIKit
import Combine

protocol ProfileViewControllerdelegate: AnyObject {
    func addMoreInsurance(_ profileViewController: ProfileViewController)
    func logout(_ profileViewController: ProfileViewController)
    func deleteAccount(_ profileViewController: ProfileViewController)
}

final class ProfileViewController: UIViewController {
    weak var delegate: ProfileViewControllerdelegate?

    private let tableView = UITableView(
        frame: CGRect.zero,
        style: .grouped
    )
    private let headerView = ProfileHeaderView()
    private var sectionViewModels = [ProfileSectionViewModel]() {
        didSet {
            tableView.reloadData()
        }
    }
    private var cancellables = Set<AnyCancellable>()

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
        
        storeController.insuranceStore.$homeInsurances
            .sink { [weak self] _ in self?.updateViewModel() }
            .store(in: &cancellables)
    }

    private func setup() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.setAppearance()

        view.layoutMargins = .init(top: 0, left: 20, bottom: 16, right: 20)
        view.backgroundColor = Color.mainBackground

        tableView.backgroundColor = Color.mainBackground
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 88
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = ProfileSectionHeaderView.height
        tableView.registerCell(ProfileButtonTableViewCell.self)
        tableView.registerCell(ProfileTitleTableViewCell.self)
        tableView.registerHeaderFooterView(ProfileSectionHeaderView.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false

        headerView.update(user: storeController.user)

        updateViewModel()

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.reloadData()
    }

    private func updateViewModel() {
        let insuranceProfileCellViewModels = storeController.insuranceStore.homeInsurances.map {
            ProfileCellViewModel(insurance: $0, storeController: storeController)
        }

        let insuranceProfileSectionViewModel = ProfileSectionViewModel(
            title: LocalizedString.Insurance.text,
            actionTitle: LocalizedString.Insurance.Aggregate.addInsurance,
            section: .insurance,
            isExpandable: true,
            items: insuranceProfileCellViewModels
        )

        let accountProfileCellViewModels = [
            ProfileCellViewModel(
                cellType: .logout
            ),
            ProfileCellViewModel(
                cellType: .deleteAccount
            )
        ]

        let accountProfileSectionViewModel = ProfileSectionViewModel(
            title: LocalizedString.Account.title,
            section: .account,
            isExpandable: false,
            items: accountProfileCellViewModels
        )

        sectionViewModels = [
            insuranceProfileSectionViewModel,
            accountProfileSectionViewModel
        ]
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let height = headerView.systemLayoutSizeFitting(CGSize(width: view.frame.width, height: .greatestFiniteMagnitude), withHorizontalFittingPriority: .required, verticalFittingPriority: .init(249)).height
        var frame = headerView.frame
        frame.size.height = height
        tableView.tableHeaderView = headerView
        tableView.tableHeaderView?.frame = frame
    }
}

extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sectionViewModels.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sectionViewModels[section].items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionViewModel = sectionViewModels[indexPath.section]
        let items = sectionViewModel.items
        let viewModel = items[indexPath.row]

        let cell = tableView.dequeueCell(ProfileTitleTableViewCell.self, indexPath: indexPath)

        if sectionViewModel.isExpandable {
            cell.shouldShowSeparator = false
        } else {
            cell.shouldShowSeparator = indexPath.row < (items.count - 1)
        }

        cell.viewModel = viewModel

        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueHeaderFooterView(ProfileSectionHeaderView.self)
        headerView.viewModel = sectionViewModels[section].headerViewModel
        headerView.delegate = self
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionViewModel = sectionViewModels[indexPath.section]

        if sectionViewModel.isExpandable && sectionViewModel.isExpanded {
            return 0
        }

        return ProfileTitleTableViewCell.height
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        ProfileSectionHeaderView.height
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewModel = sectionViewModels[indexPath.section]
        switch viewModel.items[indexPath.row].cellType {
        case .logout:
            delegate?.logout(self)
        case .deleteAccount:
            let alert = UIAlertController(
                title: LocalizedString.Account.deleteWarning,
                message: nil,
                preferredStyle: .alert
            )
            alert.addAction(
                .init(
                    title: LocalizedString.Generic.ok,
                    style: .destructive,
                    handler: { action in
                        alert.dismiss(animated: true) {
                            self.delegate?.deleteAccount(self)
                        }
                })
            )
            alert.addAction(
                .init(
                    title: LocalizedString.Generic.cancel,
                    style: .cancel,
                    handler: { action in
                        alert.dismiss(animated: true)
                })
            )
            present(alert, animated: true)
        case .insurance(let insurance):
            break
        case .expandable:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ProfileViewController: ProfileSectionHeaderViewDelegate {
    func profileSectionHeaderView(_ profileSectionHeaderView: ProfileSectionHeaderView, didPressWithViewModel viewModel: ProfileSectionHeaderViewModel) {
        switch viewModel.section {
        case .insurance:
            self.delegate?.addMoreInsurance(self)
        default: break
        }
    }


}
