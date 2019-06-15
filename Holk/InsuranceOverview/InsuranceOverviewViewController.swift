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
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var containerView: UIView!
    
    var childSegmentViewControllers: [UIViewController] = []
    var insuranceOvewviewDetailViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        view.backgroundColor = Color.mainBackgroundColor
        containerView.backgroundColor = .clear
        
        // TODO: Update the font
        headerLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        
        segmentedControl.removeAllSegments()
        segmentedControl.insertSegment(withTitle: "Försäkringar", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Kostnader", at: 1, animated: false)
        segmentedControl.setDividerImage(UIImage(), forLeftSegmentState: UIControl.State(), rightSegmentState:
            UIControl.State(), barMetrics: .default)
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.42),
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)
            ], for: UIControl.State.normal)
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)
            ], for: UIControl.State.selected)
        
        segmentedControl.setBackgroundImage(UIImage(), for: UIControl.State.normal, barMetrics: .default)
        segmentedControl.setBackgroundImage(UIImage(), for: UIControl.State.selected, barMetrics: .default)
        segmentedControl.tintColor = .white
//        segmentedControl.addTarget(self, action: #selector(segmentChanged(sender:)), for: .valueChanged)
        
        segmentedControl.selectedSegmentIndex = 0
    }
    
    @objc private func segmentChanged(sender: UISegmentedControl) {
        let childSegmentViewController = childSegmentViewControllers[sender.selectedSegmentIndex]
        addChild(childSegmentViewController)
        childSegmentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(childSegmentViewController.view)
        childSegmentViewController.didMove(toParent: self)
    }
}
