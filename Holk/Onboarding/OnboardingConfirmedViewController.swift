//
//  OnboardingConfirmedViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2019-09-03.
//  Copyright © 2019 Holk. All rights reserved.
//
import UIKit

import Foundation

final class OnboardingConfirmedViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelView: UILabel!
    
    // MARK: - Public variables
    var providerType: InsuranceProviderType?
    var provider: InsuranceProvider?
    weak var coordinator: OnboardingCoordinator?
    
    // MARK: - Overridden methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.mainHighlightColor
        
        imageView.image = UIImage.fontAwesomeIcon(name: .check, style: .regular, textColor: Color.secondaryBackgroundColor, size: FontAwesome.largeIconSize)
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = Color.mainForegroundColor.cgColor
        
        if let providerType = providerType, let provider = provider {
            labelView.text = "Snyggt, \n\(provider.displayName) \(providerType.rawValue) insurance\n has been added"
        } else {
            labelView.text = "Snyggt, \ndå fortsätter vi"
        }
        
        labelView.textColor = Color.mainForegroundColor
        labelView.font = Font.extraBold(.header)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.coordinator?.finishOnboarding()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.setHidesBackButton(true, animated: animated)
    }
}
