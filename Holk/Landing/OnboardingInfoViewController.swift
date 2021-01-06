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
    weak var coordinator: ShellCoordinator?
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        navigationItem.setAppearance()
        
        view.backgroundColor = Color.mainBackground

        titleLabel.text = LocalizedString.Onboarding.Information.title
        titleLabel.font = Font.extraBold(.title)
        titleLabel.textColor = Color.mainForeground
        titleLabel.numberOfLines = 0

        subtitleLabel.text = LocalizedString.Onboarding.Information.subtitle
        subtitleLabel.font = Font.regular(.label)
        subtitleLabel.textColor = Color.mainForeground
        subtitleLabel.numberOfLines = 0

        headerLabel.text = LocalizedString.Onboarding.Information.steps
        headerLabel.font = Font.semiBold(.title)
        headerLabel.textColor = Color.mainForeground
        headerLabel.numberOfLines = 0

        loginLabel.text = LocalizedString.Onboarding.Information.firstStep
        loginLabel.font = Font.regular(.description)
        loginLabel.textColor = Color.mainForeground
        loginLabel.numberOfLines = 0

        answerQuestionLabel.text = LocalizedString.Onboarding.Information.secondStep
        answerQuestionLabel.font = Font.regular(.description)
        answerQuestionLabel.textColor = Color.mainForeground
        answerQuestionLabel.numberOfLines = 0

        analyseLabel.text = LocalizedString.Onboarding.Information.thirdStep
        analyseLabel.font = Font.regular(.description)
        analyseLabel.textColor = Color.mainForeground
        analyseLabel.numberOfLines = 0

        loginImage.image = UIImage(systemName: "checkmark.shield")
        loginImage.tintColor = Color.mainForeground
        loginImage.contentMode = .scaleAspectFit
        answerQuestionImage.image = UIImage(systemName: "bubble.left")
        answerQuestionImage.contentMode = .scaleAspectFit
        answerQuestionImage.tintColor = Color.mainForeground
        analyseImage.image = UIImage(systemName: "bell.circle")
        analyseImage.contentMode = .scaleAspectFit
        analyseImage.tintColor = Color.mainForeground

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
        loginStackView.spacing = 24

        let answerQuestionStackView = UIStackView(arrangedSubviews: [answerQuestionImage, answerQuestionLabel])
        answerQuestionStackView.spacing = 24

        let analyseStackView = UIStackView(arrangedSubviews: [analyseImage, analyseLabel])
        analyseStackView.spacing = 24

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
}
