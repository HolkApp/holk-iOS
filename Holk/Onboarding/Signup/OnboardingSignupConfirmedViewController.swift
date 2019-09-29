//
//  OnboardingSignupConfirmedViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2019-09-03.
//  Copyright © 2019 Holk. All rights reserved.
//
import UIKit

import Foundation

final class OnboardingSignupConfirmedViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = #imageLiteral(resourceName: "check")
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = Color.mainForegroundColor.cgColor
        
        labelView.text = "Snyggt, \ndå fortsätter vi"
        labelView.textColor = Color.mainForegroundColor
        labelView.font = Font.extraBold(.header)
    }
    
}
