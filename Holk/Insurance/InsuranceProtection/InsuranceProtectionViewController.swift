//
//  InsuranceProtectionViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2019-06-16.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

final class InsuranceProtectionViewController: UIViewController {
    weak var coordinator: InsuranceProtectionCoordinator?

    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
}
