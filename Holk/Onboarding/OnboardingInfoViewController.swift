//
//  OnboardingInfoViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2019-05-01.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

class OnboardingInfoViewController: UIViewController {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet weak private var headerLabel: UILabel!
    @IBOutlet weak private var loginImage: UIImageView!
    @IBOutlet weak private var loginLabel: UILabel!
    @IBOutlet weak private var answerQuestionImage: UIImageView!
    @IBOutlet weak private var answerQuestionLabel: UILabel!
    @IBOutlet weak private var analyseImage: UIImageView!
    @IBOutlet weak private var analyseLabel: UILabel!
    @IBOutlet weak private var verticalStackView: UIStackView!
    
    weak var coordinator: BackNavigation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        navigationController?.isNavigationBarHidden = false
        loginImage.image = .fontAwesomeIcon(name: .fileCheck, style: .regular, textColor: Color.mainForegroundColor, size: Font.iconSize)
        answerQuestionImage.image = .fontAwesomeIcon(name: .commentAltSmile, style: .regular, textColor: Color.mainForegroundColor, size: Font.iconSize)
        analyseImage.image = .fontAwesomeIcon(name: .bellExclamation, style: .regular, textColor: Color.mainForegroundColor, size: Font.iconSize)
    }
}
