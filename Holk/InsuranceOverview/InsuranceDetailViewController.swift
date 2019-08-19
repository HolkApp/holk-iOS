//
//  InsuranceDetailViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2019-06-21.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

protocol InsuranceDetailViewControllerDelegate: class {
    func controllerDismissed(insuranceDetailViewController: InsuranceDetailViewController)
}

final class InsuranceDetailViewController: UIViewController {
    
    @IBOutlet private weak var container: UIView!
    @IBOutlet private weak var typeLabel: UILabel!
    
    @objc private func backTapped(_ sender: UIButton) {
        delegate?.controllerDismissed(insuranceDetailViewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "RoundedClose").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(backTapped(_:)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.setHidesBackButton(true, animated: animated)
    }
    
    weak var delegate: InsuranceDetailViewControllerDelegate?
}
