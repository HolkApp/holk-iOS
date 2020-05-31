//
//  InsuranceViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2020-05-31.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit

final class InsuranceViewController: UIViewController {
    // MARK: - Private variables
    private var storeController: StoreController
    private var insurnace: Insurance

    init(storeController: StoreController, insurnace: Insurance) {
        self.storeController = storeController
        self.insurnace = insurnace

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
