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
    @IBOutlet weak private var OKButton: HolkButton!
    
    weak var coordinator: BackNavigation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        navigationItem.setHidesBackButton(true, animated: false)
        let backIcon = UIImage.fontAwesomeIcon(name: .chevronLeft, style: .regular, textColor: Color.mainForegroundColor, size: Font.iconSize)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: backIcon, style: .plain, target: self, action: #selector(back(sender:)))
        navigationController?.isNavigationBarHidden = false
        
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
        OKButton.titleLabel?.font = Font.semibold(.caption)
        OKButton.setTitleColor(Color.mainForegroundColor, for: UIControl.State())
        OKButton.backgroundColor = Color.mainButtonBackgroundColor
        verticalStackView.setCustomSpacing(35, after: subtitleLabel)
        verticalStackView.setCustomSpacing(30, after: headerLabel)
        
        OKButton.addTarget(self, action: #selector(back(sender:)), for: .touchUpInside)
        
        loginImage.image = .fontAwesomeIcon(name: .fileCheck, style: .light, textColor: Color.mainForegroundColor, size: Font.iconSize)
        answerQuestionImage.image = .fontAwesomeIcon(name: .commentAltSmile, style: .light, textColor: Color.mainForegroundColor, size: Font.iconSize)
        analyseImage.image = .fontAwesomeIcon(name: .bellExclamation, style: .light, textColor: Color.mainForegroundColor, size: Font.iconSize)
    }
    
    @objc private func back(sender: Any) {
        coordinator?.back()
    }
}
