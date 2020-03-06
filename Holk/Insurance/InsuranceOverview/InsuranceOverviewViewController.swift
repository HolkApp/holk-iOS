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
    private var headerLabelTopConstraint: NSLayoutConstraint?
    private var segmentedControlTopConstraint: NSLayoutConstraint!

    // MARK: - Public variables
    var storeController: StoreController
    var currentChildSegmentViewController: UIViewController?
    weak var coordinator: InsuranceCoordinator?
    // MARK: - Private variables
    private var childSegmentViewControllers: [UIViewController] = []
    private lazy var insurancesViewController: InsurancesViewController = {
        let insurancesViewController = InsurancesViewController(storeController: storeController)
        insurancesViewController.delegate = self
        return insurancesViewController
    }()
    private lazy var insuranceCostViewController: InsuranceCostViewController = {
        let insuranceCostViewController = StoryboardScene.InsuranceOverview.insuranceCostViewController.instantiate()
        insuranceCostViewController.delegate = self
        return insuranceCostViewController
    }()
    private lazy var profileBarButtonItem: UIBarButtonItem = {
        UIBarButtonItem(image: profileButton.imageView?.image, style: .plain, target: self, action: #selector(profileTapped(sender:)))
    }()
    private var animating: Bool = false
    private var childViewScrollViewOffset: CGFloat = 0 {
        didSet {
            guard !animating else { return }
            if childViewScrollViewOffset > 0, oldValue <= 0 {
                animating = true
                UIView.animate(withDuration: 0.1, animations: {
                    self.headerLabel.alpha = 0
                    self.profileButton.alpha = 0
                    self.navigationItem.title = self.headerLabel.text
                    self.navigationItem.rightBarButtonItem = self.profileBarButtonItem
                    self.headerLabelTopConstraint?.constant = -10
                    self.segmentedControlTopConstraint.constant = 10
                    self.view.layoutIfNeeded()
                }) { _ in
                    self.animating = false
                }
            } else if childViewScrollViewOffset <= -20, oldValue > -20 {
                animating = true
                UIView.animate(withDuration: 0.1, animations: {
                    self.headerLabel.alpha = 1
                    self.profileButton.alpha = 1
                    self.navigationItem.title = String()
                    self.navigationItem.rightBarButtonItem = nil
                    self.headerLabelTopConstraint?.constant = 20
                    self.segmentedControlTopConstraint.constant = 75
                    self.view.layoutIfNeeded()
                }) { _ in
                    self.animating = false
                }
            }
        }
    }
    
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
    
    private func setup() {
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: Color.mainForegroundColor
        ]
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
        let headerLabelTopConstraint = headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        self.headerLabelTopConstraint = headerLabelTopConstraint
        let segmentedControlTopConstraint = segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 72)
        self.segmentedControlTopConstraint = segmentedControlTopConstraint

        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(headerLabel)
        view.addSubview(profileButton)
        view.addSubview(segmentedControl)
        view.addSubview(containerView)

        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            headerLabelTopConstraint,

            profileButton.topAnchor.constraint(equalTo: headerLabel.topAnchor),
            profileButton.widthAnchor.constraint(equalToConstant: 48),
            profileButton.heightAnchor.constraint(equalToConstant: 48),
            profileButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),

            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            segmentedControlTopConstraint,
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            segmentedControl.heightAnchor.constraint(equalToConstant: 36),

            containerView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        setupSegmentedControl()
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
        
        segmentedControl.tintColor = .white
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

extension InsuranceOverviewViewController: InsurancesViewControllerDelegate {
    func insurancesViewController(_ viewController: InsurancesViewController, didScroll scrollView: UIScrollView) {
        childViewScrollViewOffset = scrollView.contentOffset.y
    }
}

extension InsuranceOverviewViewController: InsuranceCostViewControllerDelegate {
    func insuranceCostViewController(_ viewController: InsuranceCostViewController, didScroll scrollView: UIScrollView) {
        childViewScrollViewOffset = scrollView.contentOffset.y
    }
}
