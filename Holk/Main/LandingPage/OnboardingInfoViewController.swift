//
//  OnboardingInfoViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2019-05-01.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

class OnboardingInfoViewController: UIViewController {
    // MARK: - Public variables
    weak var coordinator: SessionCoordinator?
    // MARK: - Private variables
    private var scrollView = UIScrollView()
    private var titleLabel = UILabel()
    private var subtitleLabel = UILabel()
    private var headerLabel = UILabel()
    private var loginImage = UIImageView()
    private var loginLabel = UILabel()
    private var answerQuestionImage = UIImageView()
    private var answerQuestionLabel = UILabel()
    private var analyseImage = UIImageView()
    private var analyseLabel = UILabel()
    private var verticalStackView = UIStackView()
    private var childrenStackView = UIStackView()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        view.backgroundColor = Color.mainBackgroundColor
        
        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark")?.withSymbolWeightConfiguration(.medium),
            style: .plain,
            target: self,
            action: #selector(back(_:))
        )

        titleLabel.text = "Så här funkar det"
        titleLabel.font = Font.extraBold(.title)
        titleLabel.textColor = Color.mainForegroundColor
        titleLabel.numberOfLines = 0
        subtitleLabel.text = "Först granskar och analyseriar vi din försäkring och sedan jämför vi den med hur ditt vardagsliv ser ut."
        subtitleLabel.font = Font.regular(.label)
        subtitleLabel.textColor = Color.mainForegroundColor
        subtitleLabel.numberOfLines = 0
        headerLabel.text = "3 enkla steg"
        headerLabel.font = Font.semibold(.title)
        headerLabel.textColor = Color.mainForegroundColor
        headerLabel.numberOfLines = 0
        loginLabel.text = "Hämta din försäkring med Bank-ID."
        loginLabel.font = Font.regular(.description)
        loginLabel.textColor = Color.mainForegroundColor
        loginLabel.numberOfLines = 0
        answerQuestionLabel.text = "Svara på några enkla frågor om din vardag"
        answerQuestionLabel.font = Font.regular(.description)
        answerQuestionLabel.textColor = Color.mainForegroundColor
        answerQuestionLabel.numberOfLines = 0
        analyseLabel.text = "Holks AI motor analyserar och letar luckor och saknade skydd som du bör tänka på."
        analyseLabel.font = Font.regular(.description)
        analyseLabel.textColor = Color.mainForegroundColor
        analyseLabel.numberOfLines = 0

        loginImage.image = .fontAwesomeIcon(name: .fileCheck, style: .light, textColor: Color.mainForegroundColor, size: FontAwesome.mediumIconSize)
        answerQuestionImage.image = .fontAwesomeIcon(name: .commentAltSmile, style: .light, textColor: Color.mainForegroundColor, size: FontAwesome.mediumIconSize)
        analyseImage.image = .fontAwesomeIcon(name: .bellExclamation, style: .light, textColor: Color.mainForegroundColor, size: FontAwesome.mediumIconSize)

        setupLayout()
    }

    private func setupLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        loginImage.translatesAutoresizingMaskIntoConstraints = false
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        answerQuestionImage.translatesAutoresizingMaskIntoConstraints = false
        answerQuestionLabel.translatesAutoresizingMaskIntoConstraints = false
        analyseImage.translatesAutoresizingMaskIntoConstraints = false
        analyseLabel.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        childrenStackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(verticalStackView)

        verticalStackView.spacing = 8
        verticalStackView.setCustomSpacing(36, after: subtitleLabel)
        verticalStackView.setCustomSpacing(32, after: headerLabel)
        verticalStackView.axis = .vertical

        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(subtitleLabel)
        verticalStackView.addArrangedSubview(headerLabel)
        verticalStackView.addArrangedSubview(childrenStackView)

        let loginStackView = UIStackView(arrangedSubviews: [loginImage, loginLabel])
        loginStackView.distribution = .fill
        loginStackView.spacing = 32

        let answerQuestionStackView = UIStackView(arrangedSubviews: [answerQuestionImage, answerQuestionLabel])
        answerQuestionStackView.spacing = 32

        let analyseStackView = UIStackView(arrangedSubviews: [analyseImage, analyseLabel])
        analyseStackView.spacing = 32

        childrenStackView.spacing = 24
        childrenStackView.axis = .vertical

        childrenStackView.addArrangedSubview(loginStackView)
        childrenStackView.addArrangedSubview(answerQuestionStackView)
        childrenStackView.addArrangedSubview(analyseStackView)

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            verticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            verticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            verticalStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 36),
            verticalStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 40),
            verticalStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -36),
            verticalStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),

            loginImage.widthAnchor.constraint(equalToConstant: 48),
            loginImage.heightAnchor.constraint(greaterThanOrEqualToConstant: 48),
            answerQuestionImage.widthAnchor.constraint(equalToConstant: 48),
            answerQuestionImage.heightAnchor.constraint(greaterThanOrEqualToConstant: 48),
            analyseImage.widthAnchor.constraint(equalToConstant: 48),
            analyseImage.heightAnchor.constraint(greaterThanOrEqualToConstant: 48)
        ])

    }
    
    @objc private func back(_ sender: Any) {
        coordinator?.back()
    }
}
