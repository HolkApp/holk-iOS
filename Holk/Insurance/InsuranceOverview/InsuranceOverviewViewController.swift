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
    private let segmentedControl = HolkSegmentedControl()
    private let profileButton = UIButton()
    private let containerView = UIView()

    // MARK: - Public variables
    var storeController: StoreController
    var currentChildSegmentViewController: UIViewController?
    weak var coordinator: InsuranceCoordinator?
    // MARK: - Private variables
    private var childSegmentViewControllers: [UIViewController] = []
    private lazy var insurancesViewController = InsurancesViewController(storeController: storeController)
    private lazy var insuranceCostViewController = StoryboardScene.InsuranceOverview.insuranceCostViewController.instantiate()
    
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
        view.backgroundColor = Color.mainBackgroundColor
        containerView.layoutMargins = .zero
        containerView.backgroundColor = .clear
        
        headerLabel.text = "Översikt"
        headerLabel.font = Font.extraBold(.header)
        headerLabel.textColor = Color.mainForegroundColor
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        profileButton.setTitle("", for: .normal)
        profileButton.setImage(UIImage(named: "Profile"), for: .normal)
        profileButton.tintColor = Color.mainForegroundColor
        profileButton.addTarget(self, action: #selector(profileTapped(sender:)), for: .touchUpInside)
        profileButton.translatesAutoresizingMaskIntoConstraints = false

        setupSegmentedControl()

        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(headerLabel)
        view.addSubview(profileButton)
        view.addSubview(segmentedControl)
        view.addSubview(containerView)

        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),

            profileButton.topAnchor.constraint(equalTo: headerLabel.topAnchor),
            profileButton.widthAnchor.constraint(equalToConstant: 48),
            profileButton.heightAnchor.constraint(equalToConstant: 48),
            profileButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),

            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            segmentedControl.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 12),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            segmentedControl.heightAnchor.constraint(equalToConstant: 36),

            containerView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setupSegmentedControl() {
        childSegmentViewControllers = [
            insurancesViewController,
            insuranceCostViewController
        ]
        
        segmentedControl.removeAllSegments()
        segmentedControl.insertSegment(withTitle: "Försäkringar", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Kostnader", at: 1, animated: false)
        
        segmentedControl.setTitleTextAttributes(
            [
                .foregroundColor: Color.mainForegroundColor.withAlphaComponent(0.6),
                .font: Font.regular(.subtitle)
            ],
            for: .normal)
        segmentedControl.setTitleTextAttributes(
            [
                .foregroundColor: Color.mainForegroundColor,
                .font: Font.regular(.subtitle)
            ],
            for: .selected)
        
//        segmentedControl.tintColor = .white
        segmentedControl.selectionForegroundColor = Color.secondaryHighlightColor
        segmentedControl.addTarget(self, action: #selector(segmentChanged(sender:)), for: .valueChanged)
        
        segmentedControl.selectedSegmentIndex = 0
        segmentChanged(sender: segmentedControl)
    }
    
    @objc private func segmentChanged(sender: UISegmentedControl) {
        if let previousChildViewController = currentChildSegmentViewController {
            previousChildViewController.removeFromParent()
            previousChildViewController.view.removeFromSuperview()
        }
        let childSegmentViewController = childSegmentViewControllers[sender.selectedSegmentIndex]
        addChild(childSegmentViewController)
        childSegmentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(childSegmentViewController.view)
        childSegmentViewController.didMove(toParent: self)
        currentChildSegmentViewController = childSegmentViewController
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: childSegmentViewController.view.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: childSegmentViewController.view.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: childSegmentViewController.view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: childSegmentViewController.view.trailingAnchor)
        ])
    }
    
    @objc private func profileTapped(sender: UIButton) {
        coordinator?.logout()
    }
}
