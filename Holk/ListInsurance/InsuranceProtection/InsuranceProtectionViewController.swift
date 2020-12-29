//
//  InsuranceProtectionViewController.swift
//  Holk
//
//  Created by 张梦皓 on 2019-06-16.
//  Copyright © 2019 Holk. All rights reserved.
//

import UIKit

final class InsuranceProtectionViewController: UIViewController {
    weak var coordinator: InsuranceProtectionCoordinator?

    private let titleLabel = HolkLabel()
    private let imageView = UIImageView()
    private let startButton = HolkButton()

    convenience init() {
        self.init(nibName: nil, bundle: nil)

        view.backgroundColor = Color.mainBackground
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    private func setup() {
        view.addSubview(titleLabel)
        view.addSubview(imageView)
        view.addSubview(startButton)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        titleLabel.styleGuide = .header3
        titleLabel.textColor = Color.suggestionBackground
        titleLabel.text = LocalizedString.Onboarding.Landing.firstTitle
        titleLabel.setContentHuggingPriority(.required, for: .vertical)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "Gaps")

        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.styleGuide = .button1
        startButton.setTitle(LocalizedString.Generic.start, for: .normal)
        startButton.set(color: Color.suggestionBackground)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),

            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            imageView.topAnchor.constraint(equalTo: titleLabel.lastBaselineAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),

            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            startButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
        ])
    }

}
