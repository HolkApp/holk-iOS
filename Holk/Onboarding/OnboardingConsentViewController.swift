//
//  OnboardingConsentViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2020-02-12.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit
import RxSwift

final class OnboardingConsentViewController: UIViewController {
    // MARK: - Public variables
    weak var coordinator: OnboardingCoordinating?
    
    // MARK: - Private variables
    private var storeController: StoreController
    private let bag = DisposeBag()
    
    init(storeController: StoreController) {
        self.storeController = storeController
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
