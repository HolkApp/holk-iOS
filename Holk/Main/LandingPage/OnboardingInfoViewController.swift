//
//  OnboardingInfoViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2019-05-01.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

class OnboardingInfoViewController: UIViewController {
    // MARK: - IBOutlets
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        titleLabel.font = Font.extraBold(.title)
        titleLabel.textColor = Color.mainForegroundColor
        subtitleLabel.font = Font.regular(.caption)
        subtitleLabel.textColor = Color.mainForegroundColor
        headerLabel.font = Font.semibold(.title)
        headerLabel.textColor = Color.mainForegroundColor
        loginLabel.font = Font.regular(.description)
        loginLabel.textColor = Color.mainForegroundColor
        answerQuestionLabel.font = Font.regular(.description)
        answerQuestionLabel.textColor = Color.mainForegroundColor
        analyseLabel.font = Font.regular(.description)
        analyseLabel.textColor = Color.mainForegroundColor
        
        verticalStackView.setCustomSpacing(35, after: subtitleLabel)
        verticalStackView.setCustomSpacing(30, after: headerLabel)
        
        loginImage.image = .fontAwesomeIcon(name: .fileCheck, style: .light, textColor: Color.mainForegroundColor, size: FontAwesome.mediumIconSize)
        answerQuestionImage.image = .fontAwesomeIcon(name: .commentAltSmile, style: .light, textColor: Color.mainForegroundColor, size: FontAwesome.mediumIconSize)
        analyseImage.image = .fontAwesomeIcon(name: .bellExclamation, style: .light, textColor: Color.mainForegroundColor, size: FontAwesome.mediumIconSize)
    }
}
