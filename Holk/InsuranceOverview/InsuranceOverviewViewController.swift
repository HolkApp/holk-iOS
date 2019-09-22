//
//  InsuranceOverviewViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2019-06-01.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

final class InsuranceOverviewViewController: UIViewController {
    
    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var segmentedControl: HolkSegmentedControl!
    @IBOutlet private weak var profileButton: UIButton!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var headerLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var segmentedControlTopConstraint: NSLayoutConstraint!
    
    var currentChildSegmentViewController: UIViewController?
    
    private var childSegmentViewControllers: [UIViewController] = []
    private lazy var insurancesViewController: InsurancesViewController = {
        let insurancesViewController = StoryboardScene.InsuranceOverview.insurancesViewController.instantiate()
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
                    self.headerLabelTopConstraint.constant = -10
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
                    self.headerLabelTopConstraint.constant = 20
                    self.segmentedControlTopConstraint.constant = 100
                    self.view.layoutIfNeeded()
                }) { _ in
                    self.animating = false
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        childSegmentViewControllers = [
            insurancesViewController,
            insuranceCostViewController
        ]
        
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: Color.mainForegroundColor
        ]
        view.backgroundColor = Color.mainBackgroundColor
        containerView.backgroundColor = .clear
        
        headerLabel.text = "Översikt"
        headerLabel.font = Font.extraBold(.header)
        headerLabel.textColor = Color.mainForegroundColor
        
        profileButton.setTitle("", for: UIControl.State())
        profileButton.setImage(UIImage(named: "Profile"), for: UIControl.State())
        profileButton.tintColor = Color.mainForegroundColor
        profileButton.addTarget(self, action: #selector(profileTapped(sender:)), for: .touchUpInside)
        
        segmentedControl.removeAllSegments()
        segmentedControl.insertSegment(withTitle: "Försäkringar", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Kostnader", at: 1, animated: false)
        
        segmentedControl.setTitleTextAttributes([
                NSAttributedString.Key.foregroundColor: Color.mainForegroundColor.withAlphaComponent(0.42),
                NSAttributedString.Key.font: Font.light(.description)],
            for: UIControl.State.normal)
        segmentedControl.setTitleTextAttributes([
                NSAttributedString.Key.foregroundColor: Color.mainForegroundColor,
                NSAttributedString.Key.font: Font.light(.description)],
            for: UIControl.State.selected)
    
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
            containerView.leftAnchor.constraint(equalTo: childSegmentViewController.view.leftAnchor),
            containerView.rightAnchor.constraint(equalTo: childSegmentViewController.view.rightAnchor)
            ])
    }
    
    @objc private func profileTapped(sender: UIButton) {
        // Temp hack
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.coordinator?.start()
            UIApplication.shared.keyWindow?.rootViewController = appDelegate.coordinator?.navController
        }
    }
}

extension InsuranceOverviewViewController: InsurancesViewControllerDelegate {
    func InsurancesViewController(_ viewController: InsurancesViewController, didScroll scrollView: UIScrollView) {
        childViewScrollViewOffset = scrollView.contentOffset.y
    }
}

extension InsuranceOverviewViewController: InsuranceCostViewControllerDelegate {
    func insuranceCostViewController(_ viewController: InsuranceCostViewController, didScroll scrollView: UIScrollView) {
        childViewScrollViewOffset = scrollView.contentOffset.y
    }
}
