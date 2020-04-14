//
//  InsuranceOverviewViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2019-06-01.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

final class InsuranceOverviewViewController: UIViewController {
    // MARK: - IBOutlets
    private let headerLabel = UILabel()
    private let profileButton = HolkButton()
    private let containerView = UIView()
    private let addMorebutton = HolkButton()
    let insurancesViewController: InsurancesViewController

    // MARK: - Public variables
    var storeController: StoreController
    weak var coordinator: InsuranceCoordinator? {
        didSet {
            insurancesViewController.coordinator = coordinator
        }
    }
    // MARK: - Private variables
    private var childSegmentViewControllers: [UIViewController] = []
    
    // MARK: Overridden variables
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }

    init(storeController: StoreController) {
        self.storeController = storeController
        self.insurancesViewController = InsurancesViewController(storeController: storeController)

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Overridden methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func setup() {
        containerView.layoutMargins = .zero
        containerView.backgroundColor = .clear
        containerView.translatesAutoresizingMaskIntoConstraints = false

        headerLabel.text = "Översikt"
        headerLabel.font = Font.extraBold(.header)
        headerLabel.textColor = Color.mainForegroundColor
        headerLabel.translatesAutoresizingMaskIntoConstraints = false

        profileButton.set(color: Color.mainForegroundColor, image: UIImage(named: "Profile"))
        profileButton.addTarget(self, action: #selector(profileTapped(sender:)), for: .touchUpInside)
        profileButton.translatesAutoresizingMaskIntoConstraints = false

        addChild(insurancesViewController)
        insurancesViewController.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(insurancesViewController.view)
        insurancesViewController.didMove(toParent: self)

        addMorebutton.contentMode = .center
        addMorebutton.imageView?.contentMode = .scaleAspectFit
        let addMoreImage = UIImage(systemName: "plus.circle")?.withRenderingMode(.alwaysTemplate).withSymbolWeightConfiguration(.thin, pointSize: 48)
        addMorebutton.set(color: Color.mainForegroundColor, image: addMoreImage)
        addMorebutton.addTarget(self, action: #selector(addMoreTapped(sender:)), for: .touchUpInside)
        addMorebutton.translatesAutoresizingMaskIntoConstraints = false

        view.backgroundColor = Color.mainBackgroundColor
        view.addSubview(headerLabel)
        view.addSubview(profileButton)
        view.addSubview(containerView)
        view.addSubview(addMorebutton)

        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 4),

            profileButton.topAnchor.constraint(equalTo: headerLabel.topAnchor),
            profileButton.widthAnchor.constraint(equalToConstant: 48),
            profileButton.heightAnchor.constraint(equalToConstant: 48),
            profileButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            containerView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            containerView.topAnchor.constraint(equalTo: insurancesViewController.view.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: insurancesViewController.view.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: insurancesViewController.view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: insurancesViewController.view.trailingAnchor),

            addMorebutton.widthAnchor.constraint(equalToConstant: 48),
            addMorebutton.heightAnchor.constraint(equalToConstant: 48),
            addMorebutton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            addMorebutton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12)
        ])
    }

    @objc private func addMoreTapped(sender: UIButton) {
        insurancesViewController.numberOfInsurances += 1
    }
    
    @objc private func profileTapped(sender: UIButton) {
        coordinator?.logout()
    }
}
