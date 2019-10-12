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
        
        view.backgroundColor = Color.mainHighlightColor
        
        imageView.image = UIImage.fontAwesomeIcon(name: .check, style: .regular, textColor: Color.secondaryBackgroundColor, size: FontAwesome.largeIconSize)
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = Color.mainForegroundColor.cgColor
        
        labelView.text = "Snyggt, \ndå fortsätter vi"
        labelView.textColor = Color.mainForegroundColor
        labelView.font = Font.extraBold(.header)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if let window = UIApplication.shared.delegate?.window {
                window?.rootViewController = TabBarController()
            }
        }
    }
}
