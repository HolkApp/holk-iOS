//
//  InsuranceCostViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2019-06-16.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

protocol InsuranceCostViewControllerDelegate: AnyObject {
    func insuranceCostViewController(_ viewController: InsuranceCostViewController, didScroll scrollView: UIScrollView)
}

final class InsuranceCostViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    // MARK: - Public variables
    var insuranceDetailCoordinator: InsuranceDetailCoordinator?
    weak var delegate: InsuranceCostViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        view.backgroundColor = Color.mainBackgroundColor
        
        tableView.backgroundColor = .clear
        
        tableView.estimatedRowHeight = 224
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.alwaysBounceVertical = false
        registerForPreviewing(with: self, sourceView: tableView)
        
        let insuranceCostTableViewCell = UINib(nibName: InsuranceCostTableViewCell.identifier, bundle: nil)
        tableView.register(insuranceCostTableViewCell, forCellReuseIdentifier: InsuranceCostTableViewCell.identifier)
        
        insuranceDetailCoordinator = InsuranceDetailCoordinator(navController: navigationController ?? UINavigationController())
        insuranceDetailCoordinator?.start()
    }
}

// MARK: - UITableViewDelegate
extension InsuranceCostViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        insuranceDetailCoordinator?.showDetail()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentSize.height > view.frame.height {
            delegate?.insuranceCostViewController(self, didScroll: scrollView)
        }
    }
}

extension InsuranceCostViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InsuranceCostTableViewCell.identifier, for: indexPath)
        return cell
    }
}

// MARK: UIViewControllerPreviewingDelegate
extension InsuranceCostViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = tableView.indexPathForRow(at: location) else { return nil }
        
        if let cellFrame = tableView.cellForRow(at: indexPath)?.frame {
            previewingContext.sourceRect = cellFrame
        }
        
        return insuranceDetailCoordinator?.insuranceDetailViewController
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        insuranceDetailCoordinator?.showDetail()
    }
}
