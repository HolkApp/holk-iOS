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
    private let loadingViewController = LoadingViewController()
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
        tableView.estimatedRowHeight = 80
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = ProfileSectionHeaderView.height
        tableView.registerCell(ProfileTableViewCell.self)
        tableView.registerCell(ProfileInsuranceTableViewCell.self)
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

        let cell: ProfileTableViewCell = {
            switch viewModel.cellType {
            case .insurance:
                let cell = tableView.dequeueCell(ProfileInsuranceTableViewCell.self, indexPath: indexPath)
                cell.delegate = self
                return cell
            default:
                return tableView.dequeueCell(ProfileTableViewCell.self, indexPath: indexPath)
            }
        }()

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

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        ProfileSectionHeaderView.height
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let sectionViewModel = sectionViewModels[indexPath.section]
        let itemViewModel = sectionViewModel.items[indexPath.row]
        switch itemViewModel.cellType {
        case .logout:
            delegate?.logout(self)
        case .deleteAccount:
            deleteAccount()
        case .insurance:
            sectionViewModel.items.forEach {
                if $0.title != itemViewModel.title {
                    $0.isExpanded = false
                }
            }
            itemViewModel.isExpanded.toggle()
            tableView.beginUpdates()
            tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
            tableView.endUpdates()
        case .expandable:
            break
        }
    }

    private func deleteAccount() {
        let alert = UIAlertController(
            title: LocalizedString.Generic.Alert.deleteWarning,
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

extension ProfileViewController: ProfileInsuranceTableViewCellDelegate {
    func refresh(_ profileInsuranceTableViewCell: ProfileInsuranceTableViewCell, insurance: Insurance) {
        addChild(loadingViewController)
        view.addSubview(loadingViewController.view)
        loadingViewController.view.frame = view.bounds
        loadingViewController.didMove(toParent: self)
        
        storeController.insuranceStore.addInsurance(insurance.insuranceProviderName) { [weak self] result in
            guard let self = self else { return }
            self.loadingViewController.removeFromParent()
            self.loadingViewController.view.removeFromSuperview()
            switch result {
            case .success: break
            case .failure(let error):
                let alert = UIAlertController(
                    title: error.localizedDescription,
                    message: nil,
                    preferredStyle: .alert
                )
                alert.addAction(
                    .init(
                        title: LocalizedString.Generic.ok,
                        style: .destructive,
                        handler: { action in
                            alert.dismiss(animated: true)
                    })
                )
                self.present(alert, animated: true)
            }
        }
    }

    func delete(_ profileInsuranceTableViewCell: ProfileInsuranceTableViewCell, insurance: Insurance) {
        // TODO: Missing backend
        print("Delete insurance ")
    }

}
