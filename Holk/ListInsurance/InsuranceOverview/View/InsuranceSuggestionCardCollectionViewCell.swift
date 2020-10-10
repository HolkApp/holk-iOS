//
//  InsurancesuggestionCardCollectionViewCell.swift
//  Holk
//
//  Created by 张梦皓 on 2020-04-21.
//  Copyright © 2020 Holk. All rights reserved.
//

import UIKit
import Lottie

class InsuranceSuggestionCardCollectionViewCell: UICollectionViewCell {
    enum SuggestionType {
        case gap
        case thinkOf
    }

    // MARK: Private variables
    private let suggestionView = UIView()
    private let suggestionValueLabel = HolkRoundBackgroundLabel()
    private let suggestionAnimationView = AnimationView()
    private let suggestionImageView = UIImageView()
    private let suggestionIllustrationView = UIStackView()
    private let suggestionLabel = HolkLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isHighlighted: Bool {
        didSet {
            suggestionView.backgroundColor = isHighlighted ? Color.suggestionCardPressDownBackground : Color.suggestionCardBackground
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        suggestionAnimationView.removeFromSuperview()
        suggestionImageView.removeFromSuperview()
    }

    func configure(_ suggestions: SuggestionsListResponse?, suggestionType: SuggestionType) {
        // TODO: Update this
        switch suggestionType {
        case .gap:
            let gaps = suggestions?.gaps ?? []
            if gaps.isEmpty {
                suggestionImageView.image = UIImage(systemName: "bell")?.withRenderingMode(.alwaysTemplate)
                suggestionImageView.tintColor = Color.mainForeground
                suggestionIllustrationView.addArrangedSubview(suggestionImageView)
            } else {
                let starAnimation = Animation.named("Bell")
                suggestionAnimationView.animation = starAnimation
                suggestionAnimationView.play(fromProgress: 0, toProgress: 0.55, loopMode: .repeat(2)) {  [weak self] finished in
                    self?.suggestionAnimationView.currentProgress = 0.85
                }
                suggestionIllustrationView.addArrangedSubview(suggestionAnimationView)
            }
            suggestionLabel.text = "Luckor"
            suggestionValueLabel.text = String(gaps.count)
            suggestionValueLabel.textColor = Color.mainForeground

        case .thinkOf:
            suggestionImageView.image = UIImage(named: "light")?.withRenderingMode(.alwaysTemplate)
            suggestionImageView.tintColor = Color.mainForeground
            suggestionIllustrationView.addArrangedSubview(suggestionImageView)

            suggestionLabel.text = "Tänk på"
            suggestionValueLabel.text = suggestions.flatMap { String($0.thinkOfs.count) }
            suggestionValueLabel.textColor = Color.mainForeground
        }
    }

    private func setup() {
        contentView.layoutMargins = .init(top: 6, left: 6, bottom: 6, right: 6)
        backgroundColor = .clear

        suggestionView.layoutMargins = .init(top: 8, left: 12, bottom: 8, right: 12)
        suggestionView.backgroundColor = Color.suggestionCardBackground
        suggestionView.layer.cornerRadius = 8
        suggestionView.layer.cornerCurve = .continuous
        suggestionView.translatesAutoresizingMaskIntoConstraints = false

        suggestionValueLabel.cornerRadius = 10
        suggestionValueLabel.styleGuide = .number1
        suggestionValueLabel.backgroundColor = Color.secondaryBackground
        suggestionValueLabel.textAlignment = .center
        suggestionValueLabel.translatesAutoresizingMaskIntoConstraints = false

        suggestionAnimationView.contentMode = .scaleAspectFit
        suggestionImageView.contentMode = .scaleAspectFit

        suggestionIllustrationView.backgroundColor = .clear
        suggestionIllustrationView.translatesAutoresizingMaskIntoConstraints = false

        suggestionLabel.styleGuide = .body1
        suggestionLabel.textColor = Color.mainForeground
        suggestionLabel.numberOfLines = 0
        suggestionLabel.translatesAutoresizingMaskIntoConstraints = false

        setupLayout()
    }

    private func setupLayout() {
        contentView.addSubview(suggestionView)

        suggestionView.addSubview(suggestionValueLabel)
        suggestionView.addSubview(suggestionIllustrationView)
        suggestionView.addSubview(suggestionLabel)

        NSLayoutConstraint.activate([
            suggestionValueLabel.widthAnchor.constraint(equalToConstant: 40),
            suggestionValueLabel.heightAnchor.constraint(equalToConstant: 30),
            suggestionValueLabel.centerYAnchor.constraint(equalTo: suggestionIllustrationView.centerYAnchor),
            suggestionValueLabel.trailingAnchor.constraint(lessThanOrEqualTo: suggestionView.layoutMarginsGuide.trailingAnchor),

            suggestionIllustrationView.widthAnchor.constraint(equalToConstant: 36),
            suggestionIllustrationView.heightAnchor.constraint(equalToConstant: 36),
            suggestionIllustrationView.leadingAnchor.constraint(equalTo: suggestionView.layoutMarginsGuide.leadingAnchor),
            suggestionIllustrationView.topAnchor.constraint(equalTo: suggestionView.layoutMarginsGuide.topAnchor),

            suggestionLabel.leadingAnchor.constraint(equalTo: suggestionIllustrationView.leadingAnchor),
            suggestionLabel.topAnchor.constraint(equalTo: suggestionIllustrationView.bottomAnchor, constant: 4),
            suggestionLabel.trailingAnchor.constraint(equalTo: suggestionView.layoutMarginsGuide.trailingAnchor),
            suggestionLabel.lastBaselineAnchor.constraint(equalTo: suggestionView.layoutMarginsGuide.bottomAnchor, constant: -6),

            suggestionView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            suggestionView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            suggestionView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            suggestionView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])
    }
}


